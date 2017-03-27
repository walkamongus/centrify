# == Class centrify::adjoin::password
#
# This class is called from centrify for
# joining AD using a username and password.
#
class centrify::adjoin::password (
  $join_user,
  $join_password,
  $domain,
  $server,
  $container,
  $zone,
  $precreate,
  $extra_args,
){

  $_server_opt = $server ? {
    undef   => '',
    default => "-s '${server}'",
  }

  $_container_opt = $container ? {
    undef   => '',
    default => "-c '${container}'",
  }

  $_zone_opt = $zone ? {
    undef   => '-w',
    default => "-z '${zone}'"
  }

  $_opts = [
    '-V',
    $_zone_opt,
    "-u '${join_user}'",
    '-p $CENTRIFY_JOIN_PASSWORD',
    $_container_opt,
    $_server_opt,
  ]

  $_join_opts = delete(concat($_opts, $extra_args), '')
  $_options   = join($_join_opts, ' ')
  $_command   = "adjoin ${_options} '${domain}'"

  if $precreate {
    exec { 'adjoin_precreate_with_password':
      path        => '/usr/bin:/usr/sbin:/bin',
      command     => "${_command} -P",
      environment => "CENTRIFY_JOIN_PASSWORD='${join_password}'",
      unless      => "adinfo -d | grep ${domain}",
      before      => Exec['adjoin_with_password'],
    }
  }

  exec { 'adjoin_with_password':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => $_command,
    environment => "CENTRIFY_JOIN_PASSWORD='${join_password}'",
    unless      => "adinfo -d | grep ${domain}",
    notify      => Exec['run_adflush_and_adreload'],
  }

  exec { 'run_adflush_and_adreload':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'adflush && adreload',
    refreshonly => true,
  }

}
