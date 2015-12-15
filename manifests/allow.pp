# == Define tcpwrappers::allow
#
# == Parameters
#
# [*pattern*]
#   The allow pattern based on the content of the man page.
#
# [*order*]
#   The order where you want this rule to appear.  10000 is the default.  IF
#   you don't specify an order, the rules will be listed in alphabetical
#   order.  Defaults to 1000.
#
# [*svc*]
#   An alternate name variable for the service.  This is useful if you wish to
#   use the same service name more than once for some reason.
#
define tcpwrappers::allow (
    $pattern,
    $order = '1000',
    $svc = 'nil'
) {
    validate_string($order)
    validate_string($svc)

    $l_name = inline_template('<%= @name.gsub(/\s+/,"_") %>')

    concat_fragment { "tcpwrappers+${order}.${l_name}.allow":
      content => template('tcpwrappers/tcpwrappers.allow.erb')
    }
}
