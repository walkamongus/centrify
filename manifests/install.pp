# == Class centrify::install
#
# This class is called from centrify for install.
#
class centrify::install {

  package { 'centrifydc':
    ensure => $::centrify::dc_package_ensure,
    name   => $::centrify::dc_package_name,
  }

  package { 'centrifydc_openssh':
    ensure => $::centrify::sshd_package_ensure,
    name   => $::centrify::sshd_package_name,
  }

}
