# comment at the top

# comment before command
# multiline
def foo_bar [ # comment at [
    foo: string # comment for arg
    bar: int # another comment
] { # comment at {
  # comment in body
  [
    foo # comment in list
    # another comment
    bar
  ];
  {
    foo: foo # comment in record
    # another comment
    bar: bar
  } # comment at }
  ( # comment at (
    foo # comment in parenthesis
    bar # another comment
  )
}

# top level comment
# multiline  
