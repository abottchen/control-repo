class hieratest::test (
  $myarr = {},
) {
  notify {"The ADB hash is: ${myarr}":}
  
  $test = lookup("hieratest::test::myarr")
  notify {"The lookup hash is: ${test}":}

  $test2 = lookup("hieratest::test::myarr", {'merge' =>  'deep'})
  notify {"The deep lookup hash is: ${test2}":}
}