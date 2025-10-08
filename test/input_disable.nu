# Topiary: disable
let    foo =   {}

{  ||
# other comments
  let foo =   1
  # Topiary: disable
  let bar  =  2
}

module foo {

  #Topiary: disable
  def   should_not_be_formatted []  { }

  def   should_be_formatted []  { }
}
