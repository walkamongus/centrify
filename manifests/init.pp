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
  $dc_package_name        = $::centrify::params::dc_package_name,
  $sshd_package_name      = $::centrify::params::sshd_package_name,
  $dc_package_ensure      = $::centrify::params::dc_package_ensure,
  $sshd_package_ensure    = $::centrify::params::sshd_package_ensure,
  $dc_service_name        = $::centrify::params::dc_service_name,
  $sshd_service_name      = $::centrify::params::sshd_service_name,
  $sshd_service_ensure    = $::centrify::params::sshd_service_ensure,
  $sshd_service_enable    = $::centrify::params::sshd_service_enable,
  $dc_config_file         = $::centrify::params::dc_config_file,
  $sshd_config_file       = $::centrify::params::sshd_config_file,
  $allow_users_file       = $::centrify::params::allow_users_file,
  $deny_users_file        = $::centrify::params::deny_users_file,
  $allow_groups_file      = $::centrify::params::allow_groups_file,
  $deny_groups_file       = $::centrify::params::deny_groups_file,
  $allow_users            = $::centrify::params::allow_users,
  $deny_users             = $::centrify::params::deny_users,
  $allow_groups           = $::centrify::params::allow_groups,
  $deny_groups            = $::centrify::params::deny_groups,
  $domain                 = $::centrify::params::domain,
  $container              = $::centrify::params::container,
  $join_user              = $::centrify::params::join_user,
  $join_password          = $::centrify::params::join_password,
  $krb_ticket_join        = $::centrify::params::krb_ticket_join,
  $krb_keytab             = $::centrify::params::krb_keytab,
  $initialize_krb_config  = $::centrify::params::initialize_krb_config,
  $krb_config_file        = $::centrify::params::krb_config_file,
  $krb_config             = $::centrify::params::krb_config,
  $zone                   = $::centrify::params::zone,
  $use_express_license    = $::centrify::params::use_express_license,
  $install_flush_cronjob  = $::centrify::params::install_flush_cronjob,
  $flush_cronjob_min      = $::centrify::params::flush_cronjob_min,
  $flush_cronjob_hour     = $::centrify::params::flush_cronjob_hour,
  $flush_cronjob_monthday = $::centrify::params::flush_cronjob_monthday,
  $flush_cronjob_month    = $::centrify::params::flush_cronjob_month,
  $flush_cronjob_weekday  = $::centrify::params::flush_cronjob_weekday,
  $extra_args             = $::centrify::params::extra_args,
  $precreate              = $::centrify::params::precreate,
) inherits ::centrify::params {

  if $krb_ticket_join == false {
    if ($join_user and !$join_password) {
      fail('Cannot set join_user without join_password')
    }
  }
  if ($join_password and !$join_user) {
    fail('Cannot set join_password without join_user')
  }
  if ($initialize_krb_config and empty($krb_config)) {
    fail('Cannot set initialize_krb_config without krb_config')
  }

  # validate parameters here
  if $domain                { validate_string($domain) }
  if $join_user             { validate_string($join_user) }
  if $join_password         { validate_string($join_password) }
  if $allow_users           { validate_array($allow_users) }
  if $deny_users            { validate_array($deny_users) }
  if $allow_groups          { validate_array($allow_groups) }
  if $deny_groups           { validate_array($deny_groups) }
  if $krb_config            { validate_hash($krb_config) }
  if $krb_keytab            { validate_absolute_path($krb_keytab) }
  if $krb_ticket_join       { validate_bool($krb_ticket_join) }
  if $zone                  { validate_string($zone) }
  if $use_express_license   { validate_bool($use_express_license) }
  if $install_flush_cronjob { validate_bool($install_flush_cronjob) }
  if $sshd_service_enable   { validate_bool($sshd_service_enable) }
  if $extra_args            { validate_array($extra_args) }
  if $precreate             { validate_bool($precreate) }

  if $install_flush_cronjob {
    validate_string(
      $flush_cronjob_min,
      $flush_cronjob_hour,
      $flush_cronjob_monthday,
      $flush_cronjob_month,
      $flush_cronjob_weekday,
    )
  }

  if $initialize_krb_config {
    validate_bool($initialize_krb_config)
  }

  validate_string(
    $dc_package_name,
    $sshd_package_name,
    $dc_service_name,
    $sshd_service_name,
    $dc_package_ensure,
    $sshd_package_ensure,
  )

  validate_absolute_path($dc_config_file)
  validate_absolute_path($sshd_config_file)
  validate_absolute_path($allow_users_file)
  validate_absolute_path($deny_users_file)
  validate_absolute_path($allow_groups_file)
  validate_absolute_path($deny_groups_file)
  validate_absolute_path($krb_config_file)

  class { '::centrify::install': } ->
  class { '::centrify::config': } ~>
  class { '::centrify::join': } ~>
  class { '::centrify::service': }

  contain '::centrify::install'
  contain '::centrify::config'
  contain '::centrify::join'
  contain '::centrify::service'
}
