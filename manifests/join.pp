# == Class centrify::join
#
# This class is called from centrify for joining AD.
#
class centrify::join {
  case $::centrify::join_type {
    /^selfserve$/: {
      contain '::centrify::adjoin::selfserve'
    }
    /^keytab$/: {
      contain '::centrify::adjoin::keytab'
    }
    /^password$/: {
      contain '::centrify::adjoin::password'
    }
    default: {
      fail("Invalid join_type: ${::centrify::join_type}.")
    }
  }
}
