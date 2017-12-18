class extract_ips {
  $ips = $facts["networking"]["interfaces"].map |$k,$v| {
      $v["ip"]
  }

  notify { join($ips, ","): }
}
