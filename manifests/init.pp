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
  $dc_package_name  = $::centrify::params::dc_package_name,
  $ssh_package_name = $::centrify::params::ssh_package_name,
  $dc_service_name  = $::centrify::params::dc_service_name,
  $ssh_service_name = $::centrify::params::ssh_service_name,
) inherits ::centrify::params {

  # validate parameters here

  class { '::centrify::install': } ->
  class { '::centrify::config': } ~>
  class { '::centrify::service': } ->
  Class['::centrify']
}
