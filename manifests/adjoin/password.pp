# == Class centrify::adjoin::password
#
# This class is called from centrify for
# joining AD using a username and password.
#
class centrify::adjoin::password {

  $_user     = $::centrify::join_user
  $_password = $::centrify::join_password
  $_domain   = $::centrify::domain
  $_zone     = $::centrify::zone

  if $_zone!=undef{
    
    $_command = "adjoin -V -u \'${_user}\' -p \'${_password}\' -z \'${_zone}\' \'${_domain}\'"

  } else{
    $_command = "adjoin -w -u \'${_user}\' -p \'${_password}\' \'${_domain}\'"
    }
  }
  exec { 'adjoin_with_password':
    path      => '/usr/bin:/usr/sbin:/bin',
    command   => ${_command},
    unless    => "adinfo -d | grep ${_domain}",
    notify    => Exec['run_adflush_and_adreload'],
  }

  exec { 'run_adflush_and_adreload':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'adflush && adreload',
    refreshonly => true,
  }
}
