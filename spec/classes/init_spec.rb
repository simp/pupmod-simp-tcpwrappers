require 'spec_helper'

describe 'tcpwrappers' do

  it { should create_class('tcpwrappers') }

  let (:facts) {{
    :fqdn => 'foo.bar.baz',
    :interfaces => 'lo',
    :ipaddress_lo => '127.0.0.1'
  }}

  it do
    should contain_concat_build('tcpwrappers').with({
      'order' => ['*.allow'],
      'target' => '/etc/hosts.allow',
      'require' => 'Package[tcp_wrappers]'
    })
  end

  it do
    should contain_file('/etc/hosts.allow').with({
      'owner' => 'root',
      'group' => 'root',
      'mode'  => '0644',
      'require' => 'Package[tcp_wrappers]',
      'audit' => 'content',
      'subscribe' => 'Concat_build[tcpwrappers]'
    })
  end

  it do
    should contain_file('/etc/hosts.deny').with({
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644',
      'content' => "ALL: ALL\n",
      'require' => 'Package[tcp_wrappers]'
    })
  end

  it { should contain_package('tcp_wrappers') }

  it do
    should contain_tcpwrappers__allow('ALL').with({
      'pattern' => 'LOCAL,foo.bar.baz,localhost.localdomain,127.0.0.1',
      'order' => '0'
    })
  end

end
