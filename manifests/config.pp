# == Class centrify::config
#
# This class is called from centrify for service config.
#
class centrify::config {

  $_allow_users         = $::centrify::allow_users
  $_allow_groups        = $::centrify::allow_groups
  $_deny_users          = $::centrify::deny_users
  $_deny_groups         = $::centrify::deny_groups
  $_sshd_config_ensure  = $::centrify::sshd_package_ensure

  file { 'centrifydc_config':
    ensure => present,
    path   => $::centrify::dc_config_file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { 'centrifydc_sshd_config':
    ensure => $_sshd_config_ensure,
    path   => $::centrify::sshd_config_file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  if $_allow_users {
    file { 'allow_users_file':
      ensure  => present,
      path    => $::centrify::allow_users_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template('<% @_allow_users.sort.each { |user|%><%= user + "\n" %><% } %>'),
    }->
    centrifydc_line {'pam.allow.users':
      ensure => present,
      value  => "file:${::centrify::allow_users_file}",
    }
  }

  if $_allow_groups {
    file { 'allow_groups_file':
      ensure  => present,
      path    => $::centrify::allow_groups_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template('<% @_allow_groups.sort.each { |group|%><%= group + "\n" %><% } %>'),
    }->
    centrifydc_line {'pam.allow.groups':
      ensure => present,
      value  => "file:${::centrify::allow_groups_file}",
    }
  }

  if $_deny_users {
    file { 'deny_users_file':
      ensure  => present,
      path    => $::centrify::deny_users_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template('<% @_deny_users.sort.each { |user|%><%= user + "\n" %><% } %>'),
    }->
    centrifydc_line {'pam.deny.users':
      ensure => present,
      value  => "file:${::centrify::deny_users_file}",
    }
  }

  if $_deny_groups {
    file { 'deny_groups_file':
      ensure  => present,
      path    => $::centrify::deny_groups_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template('<% @_deny_groups.sort.each { |group|%><%= group + "\n" %><% } %>'),
    }->
    centrifydc_line {'pam.deny.groups':
      ensure => present,
      value  => "file:${::centrify::deny_groups_file}",
    }
  }

}
