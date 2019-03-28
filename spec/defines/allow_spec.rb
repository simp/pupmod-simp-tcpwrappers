require 'spec_helper'

describe 'tcpwrappers::allow' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:title) { 'foo_bar' }
        let(:params) { {:pattern => 'localhost'} }
        it { is_expected.to contain_concat__fragment("tcpwrappers_#{title}") }

        context 'with triggered nets2ddq' do 
          let(:title) { 'foo_bar_ipv6' }
          let(:params) { {:pattern => 'localhost 192.168.1.1 2001:0db8:85a3:0000:0000:8a2e:0370:7334' } }
          it { is_expected.to contain_concat__fragment("tcpwrappers_#{title}") }
        end
      end
    end
  end
end
