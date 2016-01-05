# == Class centrify::service
#
# This class is meant to be called from centrify.
# It ensure the service is running.
#
class centrify::service {

  $_sshd_service_ensure  = $::centrify::sshd_package_ensure

  service { 'centrifydc':
    ensure     => running,
    name       =>  $::centrify::dc_service_name,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  if $_sshd_service_ensure == 'absent'{
    service { 'centrify-sshd':
      ensure     => stopped,
      name       => $::centrify::sshd_service_name,
      enable     => false,
      hasstatus  => true,
      hasrestart => true,
    }
  }
  else{
    service { 'centrify-sshd':
      ensure     => running,
      name       => $::centrify::sshd_service_name,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
