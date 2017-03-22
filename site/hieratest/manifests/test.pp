class hieratest::test (
  $myarr = {},
) {
  notify {"The ADB hash is: ${myarr}":}
  $test = lookup("hieratest::test::myarr")

  notify {"The lookup hash is: ${test}":}
}
