# == Class centrify::service
#
# This class is meant to be called from centrify.
# It ensure the service is running.
#
class centrify::service {

  service { $::centrify::dc_service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  service { $::centrify::ssh_service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
