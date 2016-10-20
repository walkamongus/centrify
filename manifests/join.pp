# == Class centrify::join
#
# This class is called from centrify for joining AD.
#
class centrify::join {
  if $::centrify::krb_ticket_join {
    contain '::centrify::adjoin::keytab'
  } else {
    contain '::centrify::adjoin::password'
  }
}
