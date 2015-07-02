# == Class centrify::config
#
# This class is called from centrify for service config.
#
class centrify::config {

  file { 'centrifydc_config':
    ensure => present,
    path   => $::centrify::dc_config_file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { 'centrifydc_sshd_config':
    ensure => present,
    path   => $::centrify::sshd_config_file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

}
