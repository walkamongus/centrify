# == Class centrify::join
#
# This class is called from centrify for joining AD.
#
class centrify::join {

  $_join_user             = $::centrify::join_user
  $_join_password         = $::centrify::join_password
  $_domain                = $::centrify::domain
  $_container             = $::centrify::container
  $_zone                  = $::centrify::zone
  $_extra_args            = $::centrify::extra_args
  $_precreate             = $::centrify::precreate
  $_server                = $::centrify::server
  $_krb_keytab            = $::centrify::krb_keytab
  $_krb_config            = $::centrify::krb_config
  $_initialize_krb_config = $::centrify::initialize_krb_config
  $_krb_config_file       = $::centrify::krb_config_file

  case $::centrify::join_type {
    /^selfserve$/: {
      class { '::centrify::adjoin::selfserve':
        domain     => $_domain,
        server     => $_server,
        extra_args => $_extra_args,
      }
      contain '::centrify::adjoin::selfserve'
    }
    /^keytab$/: {
      class { '::centrify::adjoin::keytab':
        join_user             => $_join_user,
        krb_keytab            => $_krb_keytab,
        initialize_krb_config => $_initialize_krb_config,
        krb_config_file       => $_krb_config_file,
        krb_config            => $_krb_config,
        domain                => $_domain,
        server                => $_server,
        container             => $_container,
        zone                  => $_zone,
        precreate             => $_precreate,
        extra_args            => $_extra_args,
      }
      contain '::centrify::adjoin::keytab'
    }
    /^password$/: {
      class { '::centrify::adjoin::password':
        join_user     => $_join_user,
        join_password => $_join_password,
        domain        => $_domain,
        server        => $_server,
        container     => $_container,
        zone          => $_zone,
        precreate     => $_precreate,
        extra_args    => $_extra_args,
      }
      contain '::centrify::adjoin::password'
    }
    default: {
      fail("Invalid join_type: ${::centrify::join_type}.")
    }
  }
}
