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
  $dc_package_name   = $::centrify::params::dc_package_name,
  $sshd_package_name = $::centrify::params::sshd_package_name,
  $dc_service_name   = $::centrify::params::dc_service_name,
  $sshd_service_name = $::centrify::params::sshd_service_name,
  $dc_config_file    = $::centrify::params::dc_config_file,
  $sshd_config_file  = $::centrify::params::sshd_config_file,
) inherits ::centrify::params {

  # validate parameters here

  class { '::centrify::install': } ->
  class { '::centrify::config': } ~>
  class { '::centrify::service': } ->
  Class['::centrify']
}
