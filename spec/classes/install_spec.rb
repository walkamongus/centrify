require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'centrify::install class with default parameters' do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('centrify::install') }
          it { is_expected.not_to contain_class('centrify::cron') }

          case facts[:osfamily]
          when 'Debian'
            it do 
              is_expected.to contain_package('centrifydc').with({
                'name'   => 'centrifydc',
                'ensure' => 'present',
              })
            end
            it do
              is_expected.to contain_package('centrifydc_openssh').with({
                'name'   => 'centrifydc-openssh',
                'ensure' => 'present',
              })
            end
          when 'RedHat', 'Amazon'
            it do 
              is_expected.to contain_package('centrifydc').with({
                'name'   => 'CentrifyDC',
                'ensure' => 'present',
              })
            end
            it do
              is_expected.to contain_package('centrifydc_openssh').with({
                'name'   => 'CentrifyDC-openssh',
                'ensure' => 'present',
              })
            end
          end
        end

        context 'centrify::install with flush cronjob enabled' do
          let(:params) do
            { :install_flush_cronjob => true }
          end

          it { is_expected.to contain_class('centrify::cron') }
        end
      end
    end
  end
end
