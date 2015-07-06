# == Class centrify::adjoin::keytab
#
# This class is called from centrify for performing
# a passwordless AD join with a Kerberos keytab
#
class centrify::adjoin::keytab {

  # adkeytab -A -K /var/tmp/join_keytab.keytab joiner
  #Administrator@CENTRIFYIMAGE.VMS's password:

  $domain = $::centrify::domain
  $user   = $::centrify::join_user
  $keytab = $::centrify::krb_keytab

  file { 'krb_keytab':
    path   => $keytab,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
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
    path    => '/usr/share/centrifydc/kerberos/bin:/usr/bin:/usr/sbin:/bin',
    command => "kinit -kt ${keytab} ${user}",
  }->
  exec { 'run_adjoin_with_keytab':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "adjoin --force -w ${domain}",
    unless      => "adinfo -d | grep ${domain}",
    refreshonly => true,
  }

}
