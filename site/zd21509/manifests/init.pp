class zd21509 ($myvar = [['user1','grp1','pwd1'],['user2','grp2','pwd2'],['user3','grp3','pwd3']]) {
  notify { $myvar[1][2]: }
}
