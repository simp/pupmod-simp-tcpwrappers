require 'spec_helper'

describe 'tcpwrappers' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          os_facts
        end

        it { is_expected.to create_class('tcpwrappers') }
        it { is_expected.to contain_package('tcp_wrappers') }

        it do
          is_expected.to contain_concat('/etc/hosts.allow')
            .with('require' => 'Package[tcp_wrappers]')
        end

        it do
          is_expected.to contain_file('/etc/hosts.deny')
            .with(
              'owner' => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'content' => "ALL: ALL\n",
              'require' => 'Package[tcp_wrappers]',
            )
        end

        it do
          is_expected.to contain_tcpwrappers__allow('ALL')
            .with(
              'pattern' => (
                [
                  'LOCAL',
                  facts[:networking][:fqdn],
                  'localhost.localdomain',
                ] + facts[:networking][:interfaces].select { |_, v| v[:ip].is_a?(String) && !v[:ip].empty? }.map { |_, v| v[:ip] }
              ).join(','),
              'order' => 0,
            )
        end
      end
    end
  end

  context 'on an unsupported Operating System version' do
    let(:facts) do
      {
        os: {
          'name' => 'CentOS',
          'release' => {
            'major' => '8',
          }
        }
      }
    end

    it 'does not create resources' do
      is_expected.not_to contain_concat('/etc/hosts.allow')
      is_expected.not_to contain_package('tcp_wrappers')
    end
  end

  context 'on an unsupported Operating System' do
    let(:facts) do
      {
        os: {
          'name' => 'Ubuntu',
          'release' => {
            'major' => '14',
             'full' => '14.999'
          }
        }
      }
    end

    it 'does not create resources' do
      is_expected.not_to contain_concat('/etc/hosts.allow')
      is_expected.not_to contain_package('tcp_wrappers')
    end
  end
end
