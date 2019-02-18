require 'spec_helper'

describe 'tcpwrappers' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let (:facts) { os_facts }

        it { is_expected.to create_class('tcpwrappers') }
        it { is_expected.to contain_package('tcp_wrappers') }

        it do
          is_expected.to contain_concat('/etc/hosts.allow').with({
            'require' => 'Package[tcp_wrappers]'
          })
        end

        it do
          is_expected.to contain_file('/etc/hosts.deny').with({
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'content' => "ALL: ALL\n",
            'require' => 'Package[tcp_wrappers]'
          })
        end

        it do
          is_expected.to contain_tcpwrappers__allow('ALL').with({
            'pattern' => 'LOCAL,foo.example.com,localhost.localdomain,10.0.2.15,127.0.0.1',
            'order'   => 0
          })
        end
      end
    end
  end
end
