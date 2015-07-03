# == Class centrify::adjoin::keytab
#
# This class is called from centrify for performing
# a passwordless AD join with a Kerberos keytab
#
class centrify::adjoin::keytab {

  # adkeytab -A -K /var/tmp/join_keytab.keytab joiner
  #Administrator@CENTRIFYIMAGE.VMS's password:

  # Administrator@CENTRIFYIMAGE.VMS's password:
  # /usr/share/centrifydc/kerberos/bin/klist

  $domain = $::centrify::domain
  $user   = $::centrify::join_user
  $keytab = $::centrify::krb_keytab

  exec { 'get_krb_ticket':
    path        => '/usr/share/centrifydc/kerberos/bin:/usr/bin:/usr/sbin:/bin',
    command     => "kinit -kt ${keytab} ${user}",
  }->
  exec { 'adjoin_with_keytab':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "adjoin --force -w ${domain}",
    unless      => "adinfo -d | grep ${domain}",
    refreshonly => true,
  }

}
