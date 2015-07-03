# == Class centrify::adjoin::password
#
# This class is called from centrify for
# joining AD using a username and password.
#
class centrify::adjoin::password {

  $user     = $::centrify::join_user
  $password = $::centrify::join_password
  $domain   = $::centrify::domain

  exec { 'adjoin_with_password':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "adjoin -w -u ${user} -p ${password} ${domain}",
    unless      => "adinfo -d | grep ${domain}",
    refreshonly => true,
  }

}
