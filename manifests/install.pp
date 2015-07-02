# == Class centrify::install
#
# This class is called from centrify for install.
#
class centrify::install {

  package { 'centrifydc':
    ensure => present,
    name   => $::centrify::dc_package_name,
  }

  package { 'centrifydc-openssh':
    ensure => present,
    name   => $::centrify::sshd_package_name,
  }

}
