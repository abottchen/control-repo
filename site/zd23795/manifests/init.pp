class zd23795 {
  $var = lookup("myvar", { default_value =>  "default"})
  notify {$var: }
}
