# == Class centrify::adjoin::selfserve
#
# This class is called from centrify for
# joining AD using a computer object that
# has already been precreated.
class centrify::adjoin::selfserve (
  $domain,
  $server,
  $extra_args,
){

  $_server_opt = $server ? {
    undef   => '',
    default => "-s '${server}'",
  }

  $_opts = [
    '-w',
    '-V',
    $_server_opt,
    '--selfserve',
  ]

  $_join_opts = delete(concat($_opts, $extra_args), '')
  $_options   = join($_join_opts, ' ')
  $_command   = "adjoin ${_options} '${domain}'"

  exec { 'adjoin_with_selfserve':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => $_command,
    unless  => "adinfo -d | grep ${domain}",
    notify  => Exec['run_adflush_and_adreload'],
  }

  exec { 'run_adflush_and_adreload':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'adflush && adreload',
    refreshonly => true,
  }

}
