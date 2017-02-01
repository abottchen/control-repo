class zd23892 {
  $hiera_test = lookup('zd23892::country_codes')
  notify{"$hiera_test":} 
}
