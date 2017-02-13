define print() {
  notify {"The value is: '${name}'": }
}

class zd24160 {
  $limits_edits = hiera_hash('linux_common::limits_edits')

  #  print {$limits_edits:}
}
