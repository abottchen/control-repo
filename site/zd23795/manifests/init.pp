class zd23795 {
  $var = lookup($facts["virtual"], { default_value => "testing" }) 
  notify {$var: }
}
