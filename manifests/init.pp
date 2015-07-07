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
  $dc_package_name     = $::centrify::params::dc_package_name,
  $sshd_package_name   = $::centrify::params::sshd_package_name,
  $dc_package_ensure   = $::centrify::params::dc_package_ensure,
  $sshd_package_ensure = $::centrify::params::sshd_package_ensure,
  $dc_service_name     = $::centrify::params::dc_service_name,
  $sshd_service_name   = $::centrify::params::sshd_service_name,
  $dc_config_file      = $::centrify::params::dc_config_file,
  $sshd_config_file    = $::centrify::params::sshd_config_file,
  $allow_users_file    = $::centrify::params::allow_users_file,
  $deny_users_file     = $::centrify::params::deny_users_file,
  $allow_groups_file   = $::centrify::params::allow_groups_file,
  $deny_groups_file    = $::centrify::params::deny_groups_file,
  $allow_users         = $::centrify::params::allow_users,
  $deny_users          = $::centrify::params::deny_users,
  $allow_groups        = $::centrify::params::allow_groups,
  $deny_groups         = $::centrify::params::deny_groups,
  $domain              = $::centrify::params::domain,
  $join_user           = $::centrify::params::join_user,
  $join_password       = $::centrify::params::join_password,
  $krb_ticket_join     = $::centrify::params::krb_ticket_join,
  $krb_keytab          = $::centrify::params::krb_keytab,
  $manage_krb_config   = $::centrify::params::manage_krb_config,
  $krb_config_file     = $::centrify::params::krb_config_file,
  $krb_config          = $::centrify::params::krb_config,
) inherits ::centrify::params {

  # validate parameters here

  class { '::centrify::install': } ->
  class { '::centrify::config': } ~>
  class { '::centrify::join': } ~>
  class { '::centrify::service': } ->
  Class['::centrify']
}
