# Set up tcpwrappers
#
# @param default_deny
#   Add a default ``ALL: ALL`` to ``/etc/hosts.deny``
#
# @param allow_all_local
#   Allow connections to all services from the local system
#
#   * This includes all representations of the local system that are available
#     via ``facter`` and shortcut notation, such as ``LOCAL``.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class tcpwrappers (
  Boolean         $default_deny    = true,
  Boolean         $allow_all_local = true
){
  package { 'tcp_wrappers': ensure => 'latest' }

  concat { '/etc/hosts.allow':
    owner          => 'root',
    group          => 'root',
    mode           => '0444',
    ensure_newline => true,
    warn           => true,
    require        => Package['tcp_wrappers']
  }

  if $default_deny {
    file { '/etc/hosts.deny':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "ALL: ALL\n",
      require => Package['tcp_wrappers']
    }
  }

  if $allow_all_local {
    $_local_allow = [
      'LOCAL',
      $facts['fqdn'],
      'localhost.localdomain',
      join(ipaddresses(),',')
    ]

    tcpwrappers::allow { 'ALL':
      pattern => join(flatten($_local_allow),','),
      order   => 0
    }
  }
}
