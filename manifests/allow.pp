# Add an entry to ``/etc/hosts.allow``
#
# @see hosts.allow(5)
#
# @name [String]
#   The name of the service
#
#   * If you want more than one entry for the same service name, simply use the
#     ``svc`` parameter and make this a descriptive name

# @param pattern
#   The allow pattern based on the content of the man page
#
# @param order
#   The order in which you want this rule to appear
#
#   * IF you don't specify an order, the rules will be listed in alphabetical
#     order
#
# @param svc
#   The name of the service
#
#   * This is useful if you wish to use the same service name more than once
#
define tcpwrappers::allow (
  Variant[String,Array[String]] $pattern,
  Integer                       $order    = 1000,
  Optional[String]              $svc      = undef
) {

  # Only do something if TCP wrappers is supported.

  if simplib::module_metadata::os_supported(load_module_metadata($module_name)) {
    concat::fragment { "tcpwrappers_${name}":
      order   => $order,
      target  => '/etc/hosts.allow',
      content => template("${module_name}/tcpwrappers.allow.erb")
    }
  }
}
