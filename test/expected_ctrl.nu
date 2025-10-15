# for
for i in [1 2 3] {
  # if
  if (true or false) {
    print "break"; break # break
  } else if not false {
    print "continue"; continue # continue
  }
  return 1 # return
}
# alias
alias ll = ls -l # alias comment
# where
ls | where $in.name == 'foo'
| where {|e| $e.item.name !~ $'^($e.index + 1)' }
# match
let foo = {name: 'bar' count: 7}
match $foo {
  {name: 'bar' count: $it} if $it < 5 => ($it + 3) # match arm comment
  # match comment
  {name: 'bar' count: $it} if not ($it >= 5) => ($it + 7)
  _ => { exit 0 }
}
match $foo {
  [a b c] => 0
  a | b | c => 42
  a
  | b
  | c => 42
  {$bar $baz} => $baz
  #  ..rest pattern
  [$x ..$y] if $x == 1 => { 'good list' }
  [..$y] => { $y }
}
match $foo { null => { return "default" } $val => $val }
# while
mut x = 0; while $x < 10 { $x = $x + 1 }; $x # while comment
# loop
loop {
  if $x > 10 { break };
  $x = $x + 1
}
# try
try {
  # error
  error make -u {
    msg: 'Some error info'
  }
}; print 'Resuming'
