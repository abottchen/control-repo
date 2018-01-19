#testing
class customfunc {
  $var = secure_data('was_id','prod')
  notify { "$var": }
}
