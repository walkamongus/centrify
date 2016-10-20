require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "centrify::adjoin::keytab class" do
          let(:params) do
            {
              :krb_ticket_join       => true,
              :join_user             => 'user',
              :krb_keytab            => '/tmp/join.keytab',
              :krb_config_file       => '/etc/krb5.conf',
              :domain                => 'example.com',
              :initialize_krb_config => true,
              :krb_config            => {
                'libdefaults'  => {
                  'default_realm' => 'EXAMPLE.COM',
                },
                'domain_realm' => {
                  'localhost.example.com' => 'EXAMPLE.COM',
                },
                'realms'       => {
                  'EXAMPLE.COM' => {
                    'kdc' => 'dc.example.com:88',
                  },
                },
              }
            }
          end

          it { is_expected.to contain_class('centrify::adjoin::keytab') }

          it do
            is_expected.to contain_file('krb_keytab').with({
              'path'  => '/tmp/join.keytab',
              'owner' => 'root',
              'group' => 'root',
              'mode'  => '0400',
            }).that_comes_before('Exec[run_kinit_with_keytab]')
          end

          it do
            is_expected.to contain_exec('remove_default_krb_config_file').with({
              'path'    => '/usr/bin:/usr/sbin:/bin',
              'command' => 'rm -f /etc/krb5.conf',
              'onlyif'  => 'grep EXAMPLE.COM /etc/krb5.conf',
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
            should contain_file('krb_configuration').with_content(
              /\[domain_realm\]\nlocalhost.example.com = EXAMPLE.COM\n/
            )
          end

          it do
            should contain_file('krb_configuration').with_content(
              /\[libdefaults\]\ndefault_realm = EXAMPLE.COM\n/
            )
          end

          it do
            should contain_file('krb_configuration').with_content(
              /\[realms\]\nEXAMPLE.COM = {\n  kdc = dc.example.com:88\n/
            )
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
              'command'     => "adjoin --force -w 'example.com'",
              'unless'      => 'adinfo -d | grep example.com',
              'refreshonly' => 'true',
            })
          end

          it do
            is_expected.to contain_exec('run_adflush_and_adreload').with({
              'path'        => '/usr/bin:/usr/sbin:/bin',
              'command'     => 'adflush && adreload',
              'refreshonly' => 'true',
            })
          end

          context 'with container set' do
            let(:params) do
              super().merge({
                :domain    => 'example.com',
                :container => 'ou=Unix computers',
              })
            end

            it do
              is_expected.to contain_exec('run_adjoin_with_keytab').with({
                'command' => "adjoin --force -w -c 'ou=Unix computers' 'example.com'",
              })
            end
          end
        end
      end
    end
  end
end
