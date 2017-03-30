[![Build Status](https://travis-ci.org/walkamongus/centrify.svg?branch=master)](https://travis-ci.org/walkamongus/centrify)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with centrify](#setup)
    * [What centrify affects](#what-centrify-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with centrify](#beginning-with-centrify)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

This module installs and configures the Centrify Express Direct Control Agent and the Centrify-enabled OpenSSH daemon.

## Module Description

Centrify Express is a free  utility for integrating Linux/Unix clients into an Active Directory infrastructure.

This module will install the DC agent and OpenSSH packages, configure their respective configuration files, and join and Active Directory domain via one of two methods:

* Username and password
* Kerberos keytab file

It also manages the Centrify DC agent and OpenSSH daemons.

## Setup

### What centrify affects

* Packages
    * centrifydc
    * centrifydc-openssh
* Files
    * /etc/centrifydc/centrifydc.conf
    * /etc/centrifydc/ssh/sshd_config
    * /etc/krb5.conf (optional initialization)
    * /etc/centrifydc/users.allow
    * /etc/centrifydc/users.deny
    * /etc/centrifydc/groups.allow
    * /etc/centrifydc/groups.deny
* Services
    * centrifydc
    * centrifydc-sshd
* Cron
    * flush and reload cronjob
* Execs
    * for username and password joins
        * the `adjoin` command is run with supplied credentials
    * for keytab joins
        * the kerberos config file (/etc/krb5.conf) will be removed if it contains the string 'EXAMPLE.COM' to allow for the module to initialize the proper contents if initialization is requested
        * the `kinit` command is run to obtain an initial TGT
        * the `adjoin` command is run to join via keytab
    * the `adflush` and `adreload` commands are run post-join
    * the `adjoin` command is run to precreate computer and extension objects if `precreate => true`
    * the `adlicense --express` command is run if `use_express_license => true` (the default) and licensed features are enabled

### Setup Requirements

* Packages
    * this module assumes that the centrify packages are available via the native package management commands i.e. the packages are available via a repository known to the system
* Puppet
    * pluginsync must be enabled
* Keytabs
    * this module does not manage keytabs -- the `krb_keytab` parameter is an absolute path to a keytab deployed in some way outside of this module

### Beginning with centrify

Set up a basic Centrify Express installation and join an Active Directory domain via username and password:

    class { '::centrify':
      domain        => 'example.com',
      join_user     => 'user',
      join_password => 'password',
    }

## Usage

Set up Centrify Express and join an Active Directory domain via a keytab (initializing a basic krb5.conf file), allow a list of users, set a configuration directive in the centrifydc.conf file, and install a daily cronjob that flushes and reloads Centrify:

    class { '::centrify':
      join_user             => 'joinuser',
      domain                => 'example.com',
      join_type             => 'keytab',
      krb_keytab            => '/etc/example.keytab',
      initialize_krb_config => true,
      install_flush_cronjob => true,
      allow_users           => [
        'user1',
        'user2',
      ],
      krb_config            => {
        'libdefaults'  => {
          'dns_lookup_realm' => 'false',
          'ticket_lifetime'  => '24h',
          'renew_lifetime'   => '7d',
          'forwardable'      => 'true',
          'rdns'             => 'false',
          'default_realm'    => 'EXAMPLE.COM',
        },
        'realms'       => {
          'EXAMPLE.COM' => {
            'kdc'          => 'kerberos.example.com',
            'admin_server' => 'kerberos.example.com',
          },
        },
        'domain_realm' => {
          '.example.com' => 'EXAMPLE.COM',
          'example.com'  => 'EXAMPLE.COM',
        },
      },
    }

    centrifydc_line { 'nss.runtime.defaultvalue.var.home':
      ensure => present,
      value  => '/home',
    }

## Reference

### Parameters

* `dc_package_name`: String. Name of the centrifydc package.
* `sshd_package_name`: String. Name of the centrifydc-openssh package.
* `dc_package_ensure`: String. Set to 'present' or 'absent'.
* `sshd_package_ensure`: String. Set to 'present' or 'absent'.
* `dc_service_name`: String. Name of the centrifydc service daemon.
* `sshd_service_name`: String. Name of the centrifydc-sshd service daemon.
* `sshd_service_ensure`: String. Value of the `ensure` parameter of the sshd service resource.
* `sshd_service_enable`: Boolean. Value for the `enable` parameter of the sshd service resource.
* `dc_config_file`: String. Absolute path to the centrifydc.conf file.
* `sshd_config_file`: String. Absolute path to the centrify sshd_config file.
* `krb_config_file`: String. Absolute path to the kerberos krb5.conf file.
* `allow_users_file`: String. Absolute path to the file listing allowed users.
* `deny_users_file`: String. Absolute path to the file listing denied users.
* `allow_groups_file`: String. Absolute path to the file listing allowed groups.
* `deny_groups_file`: String. Absolute path to the file listing denied groups.
* `allow_users`: Array. Array of allowed users to be placed in the `allow_users_file`.
* `deny_users`: Array. Array of denied users to be placed in the `deny_users_file`.
* `allow_groups`: Array. Array of allowed groups to be placed in the `allow_groups_file`.
* `deny_groups`: Array. Array of denied groups to be placed in the `denied_groups_file`.
* `domain`: String. Active Directory domain to join.
* `join_type` : Enum. What type of domain join to perform. Accepts a value of `password`, `keytab`, or `selfserve`.
* `join_user`: String. User account used to join the Active Directory domain.
* `join_password`: String. Password for `join_user` account.
* `krb_keytab`: String. Absolute path to the keytab file used to join the domain.
* `initialize_krb_config`: Boolean. Whether to initialize `krb_config_file` with the contents of `krb_config`.
* `krb_config`: Hash. Configuration used to initialize `krb_config_file` for performing a keytab join.
* `server` : String. Name of DC to join to.  Specify if using a `join_type` of `selfserve`.
* `zone`: String. Name of the zone in which to place the computer account.
* `container`: String. LDAP path to the OU container in which to place the computer account.
* `use_express_license`: Boolean. If true, set the adlicense to `express` if licensed features are enabled.
* `install_flush_cronjob`: Boolean. Whether to install a cronjob that flushes and reloads Centrify.
* `flush_cronjob_min`: String. Cron minute for flush and reload cronjob.
* `flush_cronjob_hour`: String. Cron hour for flush and reload cronjob.
* `flush_cronjob_monthday`: String. Cron day of month for flush and reload cronjob.
* `flush_cronjob_month`: String. Cron month for flush and reload cronjob.
* `flush_cronjob_weekday`: String. Cron day of week for flush and reload cronjob.
* `extra_args`: Array. Array of extra arguments to pass to the `adjoin` command.
* `precreate`: Boolean. If true, `adjoin` will run to precreate the computer and extension object in AD prior to joining.
* `manage_sshd_config`: Boolean. Specifies whether the Centrify SSH config (`sshd_config_file`) should be managed. Default is true.
* `sshd_config_content`: String, Hash, or Array. Contents of the `sshd_config_file`. Mutually exclusive with `sshd_config_source`. `sshd_config_template` takes precedence if it's specified, and this parameter can be referenced within a custom template.
* `sshd_config_template`: String. Passed to the `template()` function for the value of the `content` parameter for `sshd_config_file` resource when `manage_sshd_config=true`. Mutually exclusive with `sshd_config_source`. Both `sshd_config_content` and `sshd_config_template` can be specified, but the template takes precedence. The `sshd_config_content` parameter can be referenced in a custom template via a local scope variable of the same name.
* `sshd_config_source`: String. Value for the `source` parameter for the `sshd_config_file` resource when `manage_sshd_config=true`. Mutually exclusive with `sshd_config_content` and `sshd_config_template`


### Types
* `centrifydc_line`: Set configuration directives in the centrifydc.conf file.

### Classes
* centrify::install
* centrify::config
* centrify::service
* centrify::join
* centrify::cron
* centrify::adjoin::password
* centrify::adjoin::keytab
* centrify::adjoin::selfserve


## Limitations

This module requires Puppet >= 4.0.0.

