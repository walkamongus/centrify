require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'centrify::adjoin::selfserve class' do
          let(:params) do
            {
              :selfserve_join => true,
              :join_user      => 'user',
              :selfserve_rodc => 'domainctrlr.example.com',
              :domain         => 'example.com',
            }
          end

          it { is_expected.to contain_class('centrify::adjoin::selfserve') }

          it do
            is_expected.to contain_exec('adjoin_with_selfserve').with({
              'path'    => '/usr/bin:/usr/sbin:/bin',
              'command' => "adjoin -w -u 'user' -s 'domainctrlr.example.com' --selfserve 'example.com'",
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
              super().merge({
                :zone => 'ZONE',
              })
            end

            it do
              is_expected.to contain_exec('adjoin_with_selfserve').with({
                'command' => "adjoin -V -u 'user' -s 'domainctrlr.example.com' --selfserve -z 'ZONE' 'example.com'",
              })
            end
          end

          context 'with container set' do
            let(:params) do
              super().merge({
                :container => 'ou=Unix computers',
              })
            end

            it do
              is_expected.to contain_exec('adjoin_with_selfserve').with({
                'command' => "adjoin -w -u 'user' -s 'domainctrlr.example.com' --selfserve -c 'ou=Unix computers' 'example.com'",
              })
            end
          end

          context 'with extra_args set' do
            let(:params) do
              super().merge({
                :extra_args => [ '--name foobar' ],
              })
            end

            it do
              is_expected.to contain_exec('adjoin_with_selfserve').with({
                'command' => "adjoin -w -u 'user' -s 'domainctrlr.example.com' --selfserve --name foobar 'example.com'",
              })
            end
          end

          context 'with precreate set' do
            let(:params) do
              super().merge({
                :precreate => true,
              })
            end

            it do
              is_expected.to contain_exec('adjoin_precreate_with_selfserve').with({
                'command' => "adjoin -w -u 'user' -s 'domainctrlr.example.com' --selfserve 'example.com' -P",
              })
            end
          end
        end
      end
    end
  end
end
