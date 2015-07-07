# == Class centrify::config
#
# This class is called from centrify for service config.
#
class centrify::config {

  $allow_users  = $::centrify::allow_users
  $allow_groups = $::centrify::allow_groups
  $deny_users   = $::centrify::deny_users
  $deny_groups  = $::centrify::deny_groups

  file { 'centrifydc_config':
    ensure => present,
    path   => $::centrify::dc_config_file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { 'centrifydc_sshd_config':
    ensure => present,
    path   => $::centrify::sshd_config_file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  if $allow_users {
    file { 'allow_users_file':
      ensure  => present,
      path    => $::centrify::allow_users_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template('<% @allow_users.sort.each { |user|%><%= user %>\n<% } %>'),
    }->
    centrifydc_line {'pam.allow.users':
      ensure => present,
      value  => "file:${::centrify::allow_users_file}",
    }
  }

  if $allow_groups {
    file { 'allow_groups_file':
      ensure  => present,
      path    => $::centrify::allow_groups_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template('<% @allow_groups.sort.each { |group|%><%= group %>\n<% } %>'),
    }->
    centrifydc_line {'pam.allow.groups':
      ensure => present,
      value  => "file:${::centrify::allow_groups_file}",
    }
  }

  if $deny_users {
    file { 'deny_users_file':
      ensure  => present,
      path    => $::centrify::deny_users_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template('<% @deny_users.sort.each { |user|%><%= user %>\n<% } %>'),
    }->
    centrifydc_line {'pam.deny.users':
      ensure => present,
      value  => "file:${::centrify::deny_users_file}",
    }
  }

  if $deny_groups {
    file { 'deny_groups_file':
      ensure  => present,
      path    => $::centrify::deny_groups_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => inline_template('<% @deny_groups.sort.each { |group|%><%= group %>\n<% } %>'),
    }->
    centrifydc_line {'pam.deny.groups':
      ensure => present,
      value  => "file:${::centrify::deny_groups_file}",
    }
  }

}
