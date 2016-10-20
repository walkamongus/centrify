# == Class centrify::adjoin::password
#
# This class is called from centrify for
# joining AD using a username and password.
#
class centrify::adjoin::password {

  $_user      = $::centrify::join_user
  $_password  = $::centrify::join_password
  $_domain    = $::centrify::domain
  $_container = $::centrify::container
  $_zone      = $::centrify::zone

  $_default_join_opts = ["-u '${_user}'", "-p '${_password}'"]

  if $_container {
    $_container_opt = "-c '${_container}'"
  } else {
    $_container_opt = ''
  }

  if $_zone {
    $_zone_opt = "-z '${_zone}'"
    $_join_opts = delete(concat($_default_join_opts, $_zone_opt, $_container_opt), '')
    $_options = join($_join_opts, ' ')
    $_command = "adjoin -V ${_options} '${_domain}'"
  } else {
    $_join_opts = delete(concat($_default_join_opts, $_container_opt), '')
    $_options = join($_join_opts, ' ')
    $_command = "adjoin -w ${_options} '${_domain}'"
  }

  exec { 'adjoin_with_password':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => $_command,
    unless  => "adinfo -d | grep ${_domain}",
    notify  => Exec['run_adflush_and_adreload'],
  }

  exec { 'run_adflush_and_adreload':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'adflush && adreload',
    refreshonly => true,
  }
}
