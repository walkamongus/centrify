require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "centrify::service class with default parameters" do
          let(:params) {{ }}

          it { is_expected.to contain_class('centrify::service') }
          it { is_expected.to contain_service('centrifydc') }
          it { is_expected.to contain_service('centrify-sshd') }
        end
      end
    end
  end
end
