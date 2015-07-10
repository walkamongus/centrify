# == Class centrify::adjoin::password
#
# This class is called from centrify for
# joining AD using a username and password.
#
class centrify::adjoin::password {

  $_user     = $::centrify::join_user
  $_password = $::centrify::join_password
  $_domain   = $::centrify::domain

  exec { 'adjoin_with_password':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "adjoin -w -u ${_user} -p ${_password} ${_domain}",
    unless      => "adinfo -d | grep ${_domain}",
    refreshonly => true,
  }->
  exec { 'run_adflush_and_adreload':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'adflush && adreload',
    refreshonly => true,
  }


}
