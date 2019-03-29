require 'spec_helper'

describe 'tcpwrappers::allow' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:title) { 'foo_bar' }
        let(:params) { {:pattern => 'localhost'} }
        it { is_expected.to contain_concat__fragment("tcpwrappers_#{title}") }

        context 'with ipv6' do 
          let(:title) { 'foo_bar' }
          let(:params) { { :pattern => '2001:0db8:85a3:0000:0000:8a2e:0370:7334' } }
          it { is_expected.to contain_concat__fragment("tcpwrappers_#{title}")\
            .with_content(/\[2001:0db8:85a3:0000:0000:8a2e:0370:7334\]/) }
        end

        context 'with ipv6 cidr' do 
          let(:title) { 'foo_bar' }
          let(:params) { { :pattern => '2001:0db8:85a3:0000:0000:8a2e:0370:7334/64' } }
          it { is_expected.to contain_concat__fragment("tcpwrappers_#{title}")\
            .with_content(/\[2001:0db8:85a3:0000:0000:8a2e:0370:7334\]\/64/) }
        end

        context 'with triggered nets2ddq' do 
          let(:title) { 'foo_bar' }
          let(:params) { { :pattern => 'localhost myhost 129.3.0.1 2001:0db8:85a3:0000:0000:8a2e:0370:7334 2001:0db8:85a3:0000:0000:8a2e:0370:7334/64 234.216.15.14/16' } }
          it { is_expected.to contain_concat__fragment("tcpwrappers_#{title}")\
            .with_content(/localhost,myhost,129.3.0.1,\[2001:0db8:85a3:0000:0000:8a2e:0370:7334\],\[2001:0db8:85a3:0000:0000:8a2e:0370:7334\]\/64,234.216.0.0\/255.255.0.0/) }
        end
      end
    end
  end
end
