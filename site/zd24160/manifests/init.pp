class zd24160 {
  $limits_hash = hiera_hash('linux_common::limits_edits')

  create_resources(print, $limits_hash)
}

define print($domain, $type, $item, $value) {
  notify {"found domain ${name} - ${domain}": }
}
