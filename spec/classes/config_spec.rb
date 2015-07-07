require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "centrify::config class with default parameters" do
          let(:params) {{ }}

          it do
            is_expected.to contain_file('centrifydc_config').with({
              'ensure' => 'present',
              'path'   => '/etc/centrifydc/centrifydc.conf',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            })
          end
          it do
            is_expected.to contain_file('centrifydc_sshd_config').with({
              'ensure' => 'present',
              'path'   => '/etc/centrifydc/ssh/sshd_config',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0600',
            })
          end
        end

        context "centrify::config class with groups and users params" do
          let(:params) {{
            :allow_users  => [ 'good_user1', 'good_user2', ],
            :deny_users   => [ 'bad_user', ],
            :allow_groups => [ 'good_group', ],
            :deny_groups  => [ 'bad_group1', 'bad_group2', ],
          }}

          it do
            is_expected.to contain_file('allow_users_file').with({
              'ensure' => 'present',
              'path'   => '/etc/centrifydc/users.allow',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            })
          end

          it do 
            is_expected.to contain_centrifydc_line('pam.allow.users').with({
              'ensure' => 'present',
              'value'  => 'file:/etc/centrifydc/users.allow'
            })
          end

          it { is_expected.to contain_file('allow_users_file').with_content(
            /good_user1\\ngood_user2/
          ) }

          it do
            is_expected.to contain_file('allow_groups_file').with({
              'ensure' => 'present',
              'path'   => '/etc/centrifydc/groups.allow',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            })
          end

          it do 
            is_expected.to contain_centrifydc_line('pam.allow.groups').with({
              'ensure' => 'present',
              'value'  => 'file:/etc/centrifydc/groups.allow'
            })
          end

          it { is_expected.to contain_file('allow_groups_file').with_content(
            /good_group/
          ) }

          it do
            is_expected.to contain_file('deny_users_file').with({
              'ensure' => 'present',
              'path'   => '/etc/centrifydc/users.deny',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            })
          end

          it do 
            is_expected.to contain_centrifydc_line('pam.deny.users').with({
              'ensure' => 'present',
              'value'  => 'file:/etc/centrifydc/users.deny'
            })
          end

          it { is_expected.to contain_file('deny_users_file').with_content(
            /bad_user/
          ) }

          it do
            is_expected.to contain_file('deny_groups_file').with({
              'ensure' => 'present',
              'path'   => '/etc/centrifydc/groups.deny',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            })
          end

          it do 
            is_expected.to contain_centrifydc_line('pam.deny.groups').with({
              'ensure' => 'present',
              'value'  => 'file:/etc/centrifydc/groups.deny'
            })
          end

          it { is_expected.to contain_file('deny_groups_file').with_content(
            /bad_group1\\nbad_group2/
          ) }

        end
      end
    end
  end
end
