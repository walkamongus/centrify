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
      end
    end
  end
end
