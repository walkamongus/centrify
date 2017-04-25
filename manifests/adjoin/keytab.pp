# == Class centrify::adjoin::keytab
#
# This class is called from centrify for performing
# a passwordless AD join with a Kerberos keytab
#
class centrify::adjoin::keytab (
  $join_user,
  $krb_keytab,
  $krb_config,
  $domain,
  $server,
  $container,
  $zone,
  $extra_args,
  $precreate,
  $initialize_krb_config,
  $krb_config_file,
){

  file { 'krb_keytab':
    path   => $krb_keytab,
    owner  => 'root',
    group  => 'root',
    mode   => '0400',
    before => Exec['run_kinit_with_keytab'],
  }

  if $initialize_krb_config {
    exec {'remove_default_krb_config_file':
      path    => '/usr/bin:/usr/sbin:/bin',
      command => "rm -f ${krb_config_file}",
      onlyif  => "grep EXAMPLE.COM ${krb_config_file}",
    }->
    file { 'krb_configuration':
      ensure  => file,
      replace => false,
      path    => $krb_config_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('centrify/krb5.conf.erb'),
      before  => Exec['run_kinit_with_keytab'],
    }
  }

  $_container_opt = $container ? {
    undef   => '',
    default => "-c '${container}'",
  }

  $_server_opt = $server ? {
    undef   => '',
    default => "-s '${server}'",
  }

  $_zone_opt = $zone ? {
    undef   => '-w',
    default => "-z '${zone}'",
  }

  $_opts = [
    '-V',
    '--force',
    $_zone_opt,
    $_container_opt,
    $_server_opt,
  ]

  $_join_opts = delete(concat($_opts, $extra_args), '')
  $_options   = join($_join_opts, ' ')
  $_command   = "adjoin ${_options} '${domain}'"
  $_is_joined = "adinfo -d | grep ${domain.downcase()}"

  exec { 'run_kinit_with_keytab':
    path    => '/usr/share/centrifydc/kerberos/bin:/usr/bin:/usr/sbin:/bin',
    command => "kinit -kt ${krb_keytab} ${join_user}",
    unless  => $_is_joined,
  }

  if $precreate {
    exec { 'run_adjoin_precreate_with_keytab':
      path    => '/usr/bin:/usr/sbin:/bin',
      command => "${_command} -P",
      unless  => $_is_joined,
      require => Exec['run_kinit_with_keytab'],
      before  => Exec['run_adjoin_with_keytab'],
    }
  }

  exec { 'run_adjoin_with_keytab':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => $_command,
    unless  => $_is_joined,
    require => Exec['run_kinit_with_keytab'],
    notify  => Exec['run_adflush_and_adreload'],
  }

  exec { 'run_adflush_and_adreload':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'adflush && adreload',
    refreshonly => true,
  }

}
