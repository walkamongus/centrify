# == Class centrify::adjoin::keytab
#
# This class is called from centrify for performing
# a passwordless AD join with a Kerberos keytab
#
class centrify::adjoin::keytab {

  $_domain     = $::centrify::domain
  $_join_user  = $::centrify::join_user
  $_krb_keytab = $::centrify::krb_keytab
  $_krb_config = $::centrify::krb_config

  file { 'krb_keytab':
    path   => $_krb_keytab,
    owner  => 'root',
    group  => 'root',
    mode   => '0400',
    before => Exec['run_kinit_with_keytab'],
  }

  if $::centrify::manage_krb_config {
    file { 'krb_configuration':
      path    => $::centrify::krb_config_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('centrify/krb5.conf.erb'),
      before  => Exec['run_kinit_with_keytab'],
    }
  }

  exec { 'run_kinit_with_keytab':
    path        => '/usr/share/centrifydc/kerberos/bin:/usr/bin:/usr/sbin:/bin',
    command     => "kinit -kt ${_krb_keytab} ${_join_user}",
    refreshonly => true,
  }->
  exec { 'run_adjoin_with_keytab':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "adjoin --force -w ${_domain}",
    unless      => "adinfo -d | grep ${_domain}",
    refreshonly => true,
  }->
  exec { 'run_adflush_and_adreload':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'adflush && adreload',
    refreshonly => true,
  }

}
