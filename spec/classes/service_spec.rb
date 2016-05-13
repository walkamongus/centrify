require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'centrify::service class with default parameters' do
          let(:params) { {} }

          it { is_expected.to contain_class('centrify::service') }
          it { is_expected.to contain_service('centrifydc') }
          it { is_expected.to contain_service('centrify-sshd').with_ensure('running') }
          it { is_expected.not_to contain_exec('set_express_license') }
        end

        context 'centrify::service class with sshd service stopped' do
          let(:params) do
            { :sshd_service_ensure => 'stopped' }
          end

          it { is_expected.to contain_class('centrify::service') }
          it { is_expected.to contain_service('centrifydc') }
          it { is_expected.to contain_service('centrify-sshd').with_ensure('stopped') }
        end

        context 'centrify::service class with express license' do
          let(:params) do
            { :use_express_license => true }
          end

          it { is_expected.to contain_class('centrify::service') }
          it do
            is_expected.to contain_exec('set_express_license').with({
              'user'    => 'root',
              'path'    => ['/bin', '/usr/bin'],
              'command' => 'adlicense --express',
              'onlyif'  => 'adinfo | grep -i \'licensed[[:space:]]*features:[[:space:]]*enabled\'',
            })
          end
        end
      end
    end
  end
end
