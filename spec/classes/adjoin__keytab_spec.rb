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
            :krb_config_file => '/etc/krb5.conf',
            :domain          => 'example.com',
          }}

          it { is_expected.to contain_class('centrify::adjoin::keytab') }

          it do
            is_expected.to contain_file('krb_keytab').with({
              'path'  => '/tmp/join.keytab',
              'owner' => 'root',
              'group' => 'root',
              'mode'  => '0600',
            }).that_comes_before('File[krb_configuration]')
          end

          it do
            is_expected.to contain_file('krb_configuration').with({
              'path'  => '/etc/krb5.conf',
              'owner' => 'root',
              'group' => 'root',
              'mode'  => '0644',
            }).that_comes_before('Exec[run_kinit_with_keytab]')
          end

          it do
            is_expected.to contain_exec('run_kinit_with_keytab').with({
              'path'    => '/usr/share/centrifydc/kerberos/bin:/usr/bin:/usr/sbin:/bin',
              'command' => 'kinit -kt /tmp/join.keytab user',
            }).that_comes_before('Exec[run_adjoin_with_keytab]')
          end

          it do
            is_expected.to contain_exec('run_adjoin_with_keytab').with({
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
