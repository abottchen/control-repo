define linux_common::limits_type ( 
  $domain, 
  $type, 
  $item, 
  $value 
  ) { 
    $key = "${domain}/${type}/${item}" 
    $path_list = "domain[.=\"$domain\"][./type=\"$type\" and ./item=\"$item\"]" 
    $path_exact = "domain[.=\"$domain\"][./type=\"$type\" and ./item=\"$item\" and ./value=\"$value\"]"
    
    augeas { "limits_conf/${key}": 
    context => '/files/etc/security/limits.conf', 
    onlyif => "match ${path_exact} size != 1", 
    changes => [ 
      "rm $path_list", 
      "set domain[last()+1] $domain", 
      "set domain[last()]/type $type", 
      "set domain[last()]/item $item", 
      "set domain[last()]/value $value", 
    ], 
  } 
}
