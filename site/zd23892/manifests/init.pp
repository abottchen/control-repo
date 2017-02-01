class zd23892 {
  $hiera_test = hiera('country_codes') 
  notify{"$hiera_test":} 
}
