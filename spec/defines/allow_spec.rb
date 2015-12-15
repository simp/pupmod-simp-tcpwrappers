require 'spec_helper'

describe 'tcpwrappers::allow' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:title) { 'foo_bar' }
        let(:params) { {:pattern => 'localhost'} }
        it { is_expected.to contain_concat_fragment('tcpwrappers+1000.foo_bar.allow') }
      end
    end
  end
end
