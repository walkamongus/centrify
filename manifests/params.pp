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

  $dc_package_ensure      = 'present'
  $sshd_package_ensure    = 'present'
  $sshd_config_ensure     = 'file'
  $dc_service_name        = 'centrifydc'
  $sshd_service_name      = 'centrify-sshd'
  $sshd_service_ensure    = 'running'
  $sshd_service_enable    = true
  $dc_config_file         = '/etc/centrifydc/centrifydc.conf'
  $sshd_config_file       = '/etc/centrifydc/ssh/sshd_config'
  $krb_config_file        = '/etc/krb5.conf'
  $allow_users_file       = '/etc/centrifydc/users.allow'
  $deny_users_file        = '/etc/centrifydc/users.deny'
  $allow_groups_file      = '/etc/centrifydc/groups.allow'
  $deny_groups_file       = '/etc/centrifydc/groups.deny'
  $allow_users            = undef
  $deny_users             = undef
  $allow_groups           = undef
  $deny_groups            = undef
  $domain                 = undef
  $container              = undef
  $join_user              = undef
  $join_password          = undef
  $krb_ticket_join        = false
  $krb_keytab             = undef
  $initialize_krb_config  = false
  $krb_config             = {}
  $zone                   = undef
  $use_express_license    = false
  $install_flush_cronjob  = false
  $flush_cronjob_min      = '0'
  $flush_cronjob_hour     = '0'
  $flush_cronjob_monthday = '*'
  $flush_cronjob_month    = '*'
  $flush_cronjob_weekday  = '*'
  $precreate              = false
  $extra_args             = undef
}
