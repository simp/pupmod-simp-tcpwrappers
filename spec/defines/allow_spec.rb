require 'spec_helper'

describe 'tcpwrappers::allow' do

  let(:title) { 'foo_bar' }

  let(:params) { {:pattern => 'localhost'} }

  it { should contain_concat_fragment('tcpwrappers+1000.foo_bar.allow') }

end
