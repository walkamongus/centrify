# == Class: centrify
#
# Full description of class centrify here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class centrify (
  String $dc_package_name                 = $::centrify::params::dc_package_name,
  String $sshd_package_name               = $::centrify::params::sshd_package_name,
  String $dc_package_ensure               = 'present',
  String $sshd_package_ensure             = 'present',
  String $dc_service_name                 = 'centrifydc',
  String $sshd_service_name               = 'centrify-sshd',
  String $sshd_config_ensure              = 'file',
  String $sshd_service_ensure             = 'running',
  String $flush_cronjob_min               = '0',
  String $flush_cronjob_hour              = '0',
  String $flush_cronjob_monthday          = '*',
  String $flush_cronjob_month             = '*',
  String $flush_cronjob_weekday           = '*',
  Boolean $sshd_service_enable            = true,
  Boolean $initialize_krb_config          = false,
  Boolean $use_express_license            = false,
  Boolean $install_flush_cronjob          = false,
  Boolean $precreate                      = false,
  Hash $krb_config                        = {},
  Stdlib::Absolutepath $dc_config_file    = '/etc/centrifydc/centrifydc.conf',
  Stdlib::Absolutepath $sshd_config_file  = '/etc/centrifydc/ssh/sshd_config',
  Stdlib::Absolutepath $allow_users_file  = '/etc/centrifydc/users.allow',
  Stdlib::Absolutepath $deny_users_file   = '/etc/centrifydc/users.deny',
  Stdlib::Absolutepath $allow_groups_file = '/etc/centrifydc/groups.allow',
  Stdlib::Absolutepath $deny_groups_file  = '/etc/centrifydc/groups.deny',
  Stdlib::Absolutepath $krb_config_file   = '/etc/krb5.conf',
  Variant[Undef, Array] $allow_users      = undef,
  Variant[Undef, Array] $deny_users       = undef,
  Variant[Undef, Array] $allow_groups     = undef,
  Variant[Undef, Array] $deny_groups      = undef,
  Variant[Undef, Array] $extra_args       = undef,
  Variant[Undef, String] $domain          = undef,
  Variant[Undef, String] $container       = undef,
  Variant[Undef, String] $join_user       = undef,
  Variant[Undef, String] $join_password   = undef,
  Variant[Undef, String] $selfserve_rodc  = undef,
  Variant[Undef, String] $zone            = undef,
  Variant[Undef, Stdlib::Absolutepath] $krb_keytab   = undef,
  Enum['selfserve', 'password', 'keytab'] $join_type = 'password',
) inherits ::centrify::params {

  if ($join_type == 'password') {
    if ($join_user and !$join_password) {
      fail('Cannot set join_user without join_password')
    }
  }
  if ($initialize_krb_config and empty($krb_config)) {
    fail('Cannot set initialize_krb_config without krb_config')
  }

  class { '::centrify::install': } ->
  class { '::centrify::config': } ~>
  class { '::centrify::join': } ~>
  class { '::centrify::service': }

  contain '::centrify::install'
  contain '::centrify::config'
  contain '::centrify::join'
  contain '::centrify::service'
}
