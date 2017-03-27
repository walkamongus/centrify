require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "::centrify class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('centrify') }
          it { is_expected.to contain_class('centrify::install').that_comes_before('Class[centrify::config]') }
          it { is_expected.to contain_class('centrify::config') }
          it { is_expected.to contain_class('centrify::join').that_subscribes_to('Class[centrify::config]') }
          it { is_expected.to contain_class('centrify::service').that_subscribes_to('Class[centrify::join]') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'centrify class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { catalogue }.to raise_error(Puppet::Error) }
    end
  end
end
