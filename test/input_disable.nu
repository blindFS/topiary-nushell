# topiary: disable
let    foo =   {}

{  ||
# other comments
  let foo =   1
  # topiary: disable
  let bar  =  2
}

module foo {

  #topiary: disable
  def   should_not_be_formatted []  { }

  def   should_be_formatted []  { }
}
