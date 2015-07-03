require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "centrify::adjoin::keytab class" do
          let(:params) {{ 
            :krb_ticket_join => 'true',
            :join_user       => 'user',
            :krb_keytab      => '/tmp/join.keytab',
            :domain          => 'example.com',
          }}

          it { is_expected.to contain_class('centrify::adjoin::keytab') }

          it do
            is_expected.to contain_exec('get_krb_ticket').with({
              'path'        => '/usr/share/centrifydc/kerberos/bin:/usr/bin:/usr/sbin:/bin',
              'command'     => 'kinit -kt /tmp/join.keytab user',
            })
          end
          it do
            is_expected.to contain_exec('adjoin_with_keytab').with({
              'path'        => '/usr/bin:/usr/sbin:/bin',
              'command'     => 'adjoin --force -w example.com',
              'unless'      => 'adinfo -d | grep example.com',
              'refreshonly' => 'true',
            })
          end
        end
      end
    end
  end
end
