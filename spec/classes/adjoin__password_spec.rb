require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'centrify::adjoin::password class' do
          let(:params) do
            {
              :join_user     => 'user',
              :join_password => 'password',
              :domain        => 'example.com',
            }
          end

          it { is_expected.to contain_class('centrify::adjoin::password') }

          it do
            is_expected.to contain_exec('adjoin_with_password').with({
              'path'    => '/usr/bin:/usr/sbin:/bin',
              'command' => "adjoin -w -u 'user' -p 'password' 'example.com'",
              'unless'  => 'adinfo -d | grep example.com',
            })
          end

          it do
            is_expected.to contain_exec('run_adflush_and_adreload').with({
              'path'        => '/usr/bin:/usr/sbin:/bin',
              'command'     => 'adflush && adreload',
              'refreshonly' => 'true',
            })
          end

          context 'with zone set' do
            let(:params) do
              {
                :join_user     => 'user',
                :join_password => 'password',
                :domain        => 'example.com',
                :zone          => 'ZONE',
              }
            end

            it do
              is_expected.to contain_exec('adjoin_with_password').with({
                'command' => "adjoin -V -u 'user' -p 'password' -z 'ZONE' 'example.com'",
              })
            end
          end
        end
      end
    end
  end
end
