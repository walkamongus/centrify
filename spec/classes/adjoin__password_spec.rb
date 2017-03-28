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
              :join_type     => 'password',
              :join_user     => 'user',
              :join_password => 'password',
              :domain        => 'example.com',
            }
          end

          it { is_expected.to contain_class('centrify::adjoin::password') }

          it do
            is_expected.to contain_exec('adjoin_with_password').with({
              'path'        => '/usr/bin:/usr/sbin:/bin',
              'command'     => "adjoin -V -w -u 'user' -p $CENTRIFY_JOIN_PASSWORD 'example.com'",
              'environment' => "CENTRIFY_JOIN_PASSWORD=password",
              'unless'      => 'adinfo -d | grep example.com',
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
              is_expected.to contain_exec('adjoin_with_password').with({
                'command'     => "adjoin -V -z 'ZONE' -u 'user' -p $CENTRIFY_JOIN_PASSWORD 'example.com'",
                'environment' => "CENTRIFY_JOIN_PASSWORD=password",
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
              is_expected.to contain_exec('adjoin_with_password').with({
                'command'     => "adjoin -V -w -u 'user' -p $CENTRIFY_JOIN_PASSWORD -c 'ou=Unix computers' 'example.com'",
                'environment' => "CENTRIFY_JOIN_PASSWORD=password",
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
              is_expected.to contain_exec('adjoin_with_password').with({
                'command'     => "adjoin -V -w -u 'user' -p $CENTRIFY_JOIN_PASSWORD --name foobar 'example.com'",
                'environment' => "CENTRIFY_JOIN_PASSWORD=password",
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
              is_expected.to contain_exec('adjoin_precreate_with_password').with({
                'command'     => "adjoin -V -w -u 'user' -p $CENTRIFY_JOIN_PASSWORD 'example.com' -P",
                'environment' => "CENTRIFY_JOIN_PASSWORD=password",
              })
            end
          end
        end
      end
    end
  end
end
