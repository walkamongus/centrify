require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "centrify::install class with default parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('centrify::install') }
          case facts[:osfamily]
            when 'Debian'
              it { is_expected.to contain_package('centrifydc').with_name('centrifydc') }
              it { is_expected.to contain_package('centrifydc_openssh').with_name('centrifydc-openssh') }
            when 'RedHat', 'Amazon'
              it { is_expected.to contain_package('centrifydc').with_name('CentrifyDC') }
              it { is_expected.to contain_package('centrifydc_openssh').with_name('CentrifyDC-openssh') }
          end
        end
      end
    end
  end
end
