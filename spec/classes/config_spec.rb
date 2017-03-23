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
              'ensure' => 'file',
              'path'   => '/etc/centrifydc/centrifydc.conf',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            })
          end
          it do
            is_expected.to contain_file('centrifydc_sshd_config').only_with({
              'ensure' => 'file',
              'path'   => '/etc/centrifydc/ssh/sshd_config',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0600',
            })
          end
        end

        context "centrify::config class with groups and users params" do
          let(:params) do
            {
              :allow_users  => [ 'good_user1', 'good_user2', ],
              :deny_users   => [ 'bad_user', ],
              :allow_groups => [ 'good_group', ],
              :deny_groups  => [ 'bad_group1', 'bad_group2', ],
            }
          end

          it do
            is_expected.to contain_file('allow_users_file').with({
              'ensure' => 'file',
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

          it do
            is_expected.to contain_file('allow_users_file').with_content(
              /good_user1\ngood_user2/
            )
          end

          it do
            is_expected.to contain_file('allow_groups_file').with({
              'ensure' => 'file',
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

          it do
            is_expected.to contain_file('allow_groups_file').with_content(
              /good_group/
            )
          end

          it do
            is_expected.to contain_file('deny_users_file').with({
              'ensure' => 'file',
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

          it do
            is_expected.to contain_file('deny_users_file').with_content(
              /bad_user/
            )
          end

          it do
            is_expected.to contain_file('deny_groups_file').with({
              'ensure' => 'file',
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

          it do
            is_expected.to contain_file('deny_groups_file').with_content(
              /bad_group1\nbad_group2/
            )
          end
        end

        context "centrify::config class with sshd_config_content specified" do
          let(:params) do
            {
              :sshd_config_content => 'centrify_test',
            }
          end
          it do
            is_expected.to contain_file('centrifydc_sshd_config').with({
              'ensure'  => 'file',
              'path'    => '/etc/centrifydc/ssh/sshd_config',
              'content' => /^centrify_test$/
            })
          end
        end

        context "centrify::config class with sshd_config_template specified" do
          let(:params) do
            {
              :sshd_config_template => 'test/sshd_config.erb',
            }
          end
          it do
            is_expected.to contain_file('centrifydc_sshd_config').with({
              'ensure'  => 'file',
              'path'    => '/etc/centrifydc/ssh/sshd_config',
              'content' => /^centrify_test$/
            })
          end
        end

        context "centrify::config class with sshd_config_source specified" do
          let(:params) do
            {
              :sshd_config_source => 'puppet:///modules/profile/centrify/sshd_config.erb',
            }
          end
          it do
            is_expected.to contain_file('centrifydc_sshd_config').with({
              'ensure'  => 'file',
              'path'    => '/etc/centrifydc/ssh/sshd_config',
              'source'  => 'puppet:///modules/profile/centrify/sshd_config.erb',
            })
          end
        end

        context "centrify::config class with manage_sshd_config=false" do
          let(:params) do
            {
              :manage_sshd_config => false,
            }
          end
          it do
            is_expected.not_to contain_file('centrifydc_sshd_config')
          end
        end

        context "centrify::config class with sshd_config_content and sshd_config_template specified" do
          let(:params) do
            {
              :sshd_config_content  => {
                'TestKey'     => 'TheValue',
                'AnotherTest' => 'AnotherValue',
              },
              :sshd_config_template => 'test/sshd_config_content.erb',
            }
          end
          it do
            is_expected.to contain_file('centrifydc_sshd_config').with({
              'content' => /^TestKey TheValue\nAnotherTest AnotherValue$/
            })
          end
        end

        context "centrify::config class with sshd_config_content and sshd_config_source specified" do
          let(:params) do
            {
              :sshd_config_content => 'centrify_test',
              :sshd_config_source  => 'puppet:///modules/test/sshd_config.erb',
            }
          end
          it do
            is_expected.to raise_error(Puppet::Error, /Cannot set sshd_config_source and sshd_config_content or sshd_config_template/)
          end
        end

        context "centrify::config class with sshd_config_template and sshd_config_source specified" do
          let(:params) do
            {
              :sshd_config_template => 'test/sshd_config.erb',
              :sshd_config_source   => 'puppet:///modules/test/sshd_config.erb',
            }
          end
          it do
            is_expected.to raise_error(Puppet::Error, /Cannot set sshd_config_source and sshd_config_content or sshd_config_template/)
          end
        end
      end
    end
  end
end
