# == Class centrify::join
#
# This class is called from centrify for joining AD.
#
class centrify::join {

  if $::centrify::krb_ticket_join {
    class { '::centrify::adjoin::keytab': }
    contain '::centrify::adjoin::keytab'
  }
  elsif !$::centrify::krb_ticket_join {
    class { '::centrify::adjoin::password': }
    contain '::centrify::adjoin::password'
  }
  else {
    fail('krb_ticket_join must be set to "true" or "false".')
  }

}