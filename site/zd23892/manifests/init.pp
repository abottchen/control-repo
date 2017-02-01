class zd23892 {
  $hiera_test = lookup('country_codes')
  notify{"$hiera_test":} 
}
