require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "centrify class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('centrify::params') }
          it { is_expected.to contain_class('centrify::install').that_comes_before('centrify::config') }
          it { is_expected.to contain_class('centrify::config') }
          it { is_expected.to contain_class('centrify::service').that_subscribes_to('centrify::config') }

          it { is_expected.to contain_service('centrify') }
          it { is_expected.to contain_package('centrify').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'centrify class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('centrify') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
