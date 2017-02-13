class linux_common::limits_conf { 
  $limits_hash = hiera_hash('linux_common::limits_edits') 
  create_resources('linux_common::limits_type', $limits_hash) 
}
