require 'spec_helper'

describe 'centrify' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'centrify::cron class with cron defaults' do
          let(:params) do
            { :install_flush_cronjob => true }
          end

          it { is_expected.to contain_class('centrify::cron') }

          it do
            is_expected.to contain_cron('flush_and_reload_centrify').with({
              'ensure'   => 'present',                                                        
              'command'  => '/usr/sbin/adflush &> /dev/null; /usr/sbin/adreload &> /dev/null',
              'user'     => 'root',                                                         
              'minute'   => '0',
              'hour'     => '0',
              'monthday' => '*',
              'month'    => '*',
              'weekday'  => '*',
            })
          end
        end
      end
    end
  end
end
