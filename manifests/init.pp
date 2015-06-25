# == Class: tcpwrappers
#
# Set up tcpwrappers
#
# == Parameters
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class tcpwrappers {

    concat_build { 'tcpwrappers':
      order   => ['*.allow'],
      target  => '/etc/hosts.allow',
      require => Package['tcp_wrappers']
    }

    file { '/etc/hosts.allow':
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      require   => Package['tcp_wrappers'],
      audit     => content,
      subscribe => Concat_build['tcpwrappers']
    }

    # Deny everything by default.
    file { '/etc/hosts.deny':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "ALL: ALL\n",
      require => Package['tcp_wrappers']
    }

    package { 'tcp_wrappers': ensure => 'latest' }

    $l_to_allow = [
      'LOCAL',
      $::fqdn,
      'localhost.localdomain',
      join(ipaddresses(),',')
    ]

    tcpwrappers::allow { 'ALL':
      pattern => join(flatten($l_to_allow),','),
      order   => '0'
    }
}
