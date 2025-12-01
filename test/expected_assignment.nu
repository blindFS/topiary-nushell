let foo = 1
  | $in
  e>| $in

mut bar = 1
  # comment
  | $in
  # comment
  e+o>| $in

$bar += 1
  | $in
  # comment
  err+out>| $in

let foo = 1 | $in e>| $in
mut bar = 1 | $in e+o>| $in
$bar += 1 | $in err+out>| $in
