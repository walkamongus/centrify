# == Class centrify::adjoin::keytab
#
# This class is called from centrify for performing
# a passwordless AD join with a Kerberos keytab
#
class centrify::adjoin::keytab {

  $_user       = $::centrify::join_user
  $_krb_keytab = $::centrify::krb_keytab
  $_krb_config = $::centrify::krb_config
  $_domain     = $::centrify::domain
  $_container  = $::centrify::container
  $_zone       = $::centrify::zone

  file { 'krb_keytab':
    path   => $_krb_keytab,
    owner  => 'root',
    group  => 'root',
    mode   => '0400',
    before => Exec['run_kinit_with_keytab'],
  }

  if $::centrify::initialize_krb_config {
    exec {'remove_default_krb_config_file':
      path    => '/usr/bin:/usr/sbin:/bin',
      command => "rm -f ${$::centrify::krb_config_file}",
      onlyif  => "grep EXAMPLE.COM ${::centrify::krb_config_file}",
    }->
    file { 'krb_configuration':
      ensure  => present,
      replace => false,
      path    => $::centrify::krb_config_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('centrify/krb5.conf.erb'),
      before  => Exec['run_kinit_with_keytab'],
    }
  }


  if $_container {
    $_container_opt = "-c '${_container}'"
  } else {
    $_container_opt = ''
  }

  if $_zone {
    $_default_join_opts = ['--force', '-V']
    $_zone_opt = "-z '${_zone}'"
    $_join_opts = delete(concat($_default_join_opts, $_zone_opt, $_container_opt), '')
    $_options = join($_join_opts, ' ')
    $_command = "adjoin ${_options} '${_domain}'"
  } else {
    $_default_join_opts = ['--force', '-w']
    $_join_opts = delete(concat($_default_join_opts, $_container_opt), '')
    $_options = join($_join_opts, ' ')
    $_command = "adjoin ${_options} '${_domain}'"
  }

  exec { 'run_kinit_with_keytab':
    path        => '/usr/share/centrifydc/kerberos/bin:/usr/bin:/usr/sbin:/bin',
    command     => "kinit -kt ${_krb_keytab} ${_user}",
    refreshonly => true,
  }->
  exec { 'run_adjoin_with_keytab':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => $_command,
    unless      => "adinfo -d | grep ${_domain}",
    refreshonly => true,
  }->
  exec { 'run_adflush_and_adreload':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'adflush && adreload',
    refreshonly => true,
  }

}
