# == Class centrify::config
#
# This class is called from centrify for service config.
#
class centrify::config {

  file { $::centrify::dc_config_file:
    ensure => present,
  }

  file { $::centrify::sshd_config_file:
    ensure => present,
  }

}
