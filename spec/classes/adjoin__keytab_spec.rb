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
            :krb_ticket_join        => 'true',
            :join_user              => 'user',
            :krb_keytab             => '/tmp/join.keytab',
            :krb_config_file        => '/etc/krb5.conf',
            :domain                 => 'example.com',
            :manage_krb_config_file => 'true',
            :krb_config             => {
              'libdefaults' => {
                'default_realm' => 'EXAMPLE.COM',
              },
              'domain_realm' => {
                'localhost.example.com' => 'EXAMPLE.COM',
              },
              'realms' => {
                'EXAMPLE.COM' => {
                  'kdc' => 'dc.example.com:88',
                },
              },
            }
          }}

          it { is_expected.to contain_class('centrify::adjoin::keytab') }

          it do
            is_expected.to contain_file('krb_keytab').with({
              'path'  => '/tmp/join.keytab',
              'owner' => 'root',
              'group' => 'root',
              'mode'  => '0600',
            }).that_comes_before('Exec[run_kinit_with_keytab]')
          end

          it do
            is_expected.to contain_file('krb_configuration').with({
              'path'  => '/etc/krb5.conf',
              'owner' => 'root',
              'group' => 'root',
              'mode'  => '0644',
            }).that_comes_before('Exec[run_kinit_with_keytab]')
          end

          it { should contain_file('krb_configuration').with_content(
            /\[domain_realm\]\nlocalhost.example.com = EXAMPLE.COM\n/
          )}

          it { should contain_file('krb_configuration').with_content(
            /\[libdefaults\]\ndefault_realm = EXAMPLE.COM\n/
          )}

          it { should contain_file('krb_configuration').with_content(
            /\[realms\]\nEXAMPLE.COM = {\n  kdc = dc.example.com:88\n/
          )}

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
