# == Class centrify::install
#
# This class is called from centrify for install.
#
class centrify::install {

  package { 'centrifydc':
    ensure => present,
    name   => $::centrify::dc_package_name,
  }

  package { 'centrify-openssh':
    ensure => present,
    name   => $::centrify::ssh_package_name,
  }

}
