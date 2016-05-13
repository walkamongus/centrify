# == Class centrify::service
#
# This class is meant to be called from centrify.
# It ensures the service is running and license is correct.
#
class centrify::service {
  service { 'centrifydc':
    ensure     => running,
    name       =>  $::centrify::dc_service_name,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'centrify-sshd':
    ensure     => $::centrify::sshd_service_ensure,
    name       => $::centrify::sshd_service_name,
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

  if $centrify::use_express_license {
    exec { 'set_express_license':
      user    => 'root',
      path    => ['/bin', '/usr/bin'],
      command => 'adlicense --express',
      onlyif  => 'adinfo | grep -i \'licensed[[:space:]]*features:[[:space:]]*enabled\'',
    }
  }
}
