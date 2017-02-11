define print() {
  notice("The value is: '${name}'")
}

class zd24160 {
  #  $limits_edits = hiera_hash('linux_common::limits_edits')

  $limits_edits = ["1","2","3"]
  print {$limits_edits:}
}
