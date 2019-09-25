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
# @param package_ensure The ensure status of packages to be managed
#
# @author https://github.com/simp/pupmod-simp-tcpwrappers/graphs/contributors
#
class tcpwrappers (
  Boolean $default_deny    = true,
  Boolean $allow_all_local = true,
  String  $package_ensure  = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' }),
) {

  # Only do something if TCP wrappers is supported.
  if simplib::module_metadata::os_supported( load_module_metadata($module_name)) {

    package { 'tcp_wrappers':
      ensure => $package_ensure
    }

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
        join(simplib::ipaddresses(),',')
      ]

      tcpwrappers::allow { 'ALL':
        pattern => join(flatten($_local_allow),','),
        order   => 0
      }
    }
  }
}
