# == Class: centrify
#
# Full description of class centrify here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class centrify (
  String $dc_package_name,
  String $sshd_package_name,
  String $dc_package_ensure,
  String $sshd_package_ensure,
  String $dc_service_name,
  String $sshd_service_name,
  String $sshd_config_ensure,
  String $sshd_service_ensure,
  String $flush_cronjob_min,
  String $flush_cronjob_hour,
  String $flush_cronjob_monthday,
  String $flush_cronjob_month,
  String $flush_cronjob_weekday,
  Boolean $sshd_service_enable,
  Boolean $initialize_krb_config,
  Boolean $use_express_license,
  Boolean $install_flush_cronjob,
  Boolean $precreate,
  Boolean $manage_sshd_config,
  Array $extra_args,
  Hash $krb_config,
  Stdlib::Absolutepath $dc_config_file,
  Stdlib::Absolutepath $sshd_config_file,
  Stdlib::Absolutepath $allow_users_file,
  Stdlib::Absolutepath $deny_users_file,
  Stdlib::Absolutepath $allow_groups_file,
  Stdlib::Absolutepath $deny_groups_file,
  Stdlib::Absolutepath $krb_config_file,
  Optional[Array] $allow_users,
  Optional[Array] $deny_users,
  Optional[Array] $allow_groups,
  Optional[Array] $deny_groups,
  Optional[String] $server,
  Optional[String] $domain,
  Optional[String] $container,
  Optional[String] $join_user,
  Optional[String] $join_password,
  Optional[String] $selfserve_rodc,
  Optional[String] $zone,
  Optional[String] $sshd_config_template,
  Optional[String] $sshd_config_source,
  Optional[Variant[String, Hash, Array]] $sshd_config_content,
  Optional[Stdlib::Absolutepath] $krb_keytab,
  Enum['selfserve', 'password', 'keytab'] $join_type,
){

  if ($join_type == 'password') {
    if ($join_user and !$join_password) {
      fail('Cannot set join_user without join_password')
    }
  }
  if ($initialize_krb_config and empty($krb_config)) {
    fail('Cannot set initialize_krb_config without krb_config')
  }
  if ($sshd_config_source and ($sshd_config_content or $sshd_config_template)) {
    fail('Cannot set sshd_config_source and sshd_config_content or sshd_config_template')
  }

  class { '::centrify::install': } ->
  class { '::centrify::config': } ~>
  class { '::centrify::join': } ~>
  class { '::centrify::service': }

  contain '::centrify::install'
  contain '::centrify::config'
  contain '::centrify::join'
  contain '::centrify::service'
}
