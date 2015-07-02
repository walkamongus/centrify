# == Class centrify::params
#
# This class is meant to be called from centrify.
# It sets variables according to platform.
#
class centrify::params {

  case $::osfamily {
    'Debian': {
      $dc_package_name   = 'centrifydc'
      $sshd_package_name = 'centrifydc-openssh'
    }
    'RedHat', 'Amazon': {
      $dc_package_name   = 'CentrifyDC'
      $sshd_package_name = 'CentrifyDC-openssh'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $dc_service_name   = 'centrifydc'
  $sshd_service_name = 'centrify-sshd'
  $dc_config_file    = '/etc/centrifydc/centrifydc.conf'
  $sshd_config_file  = '/etc/centrifydc/ssh/sshd_config'

}
