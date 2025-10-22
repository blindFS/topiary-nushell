# decl_extern
export extern hello [name: string] {
    $"hello ($name)!"
}
# decl_extern no body block
extern hi [name: string --long (-s) # flags
]
# env
hide-env   ABC
with-env {ABC: 'hello'} {
  (
do -i --env {|foo, bar | print $env.ABC
  }
  foo bar
 )
}

# closure
let cls = {| foo bar  baz|
  (
    $foo +
    $bar + $baz
  )
}

# decl_export
export-env  {
$env.hello = 'hello'
}

# decl_def
def "hi there" [where: string]: nothing -> record<foo: table<baz: float>,  bar: int> {
  {foo: [["baz"]; [1.0]],
    bar: 1}
}

## multiple input/output types
def foo []: [
  int -> int, nothing -> int
] { 1 }

# decl_use
use greetings.nu hello
export use greetings.nu *
use module [foo bar]
use module ["foo" "bar"]
use module [foo "bar"]
use module ["foo" bar]

# decl_module
module greetings {
    export def hello [name: string --experimental-options: oneof<list<string>, string> # enable or disable experimental options
] {
        $"hello ($name)!"
    }

    export def hi [where: string] {
        $"hi ($where)!"
    }
};

# https://github.com/blindFS/topiary-nushell/issues/35
def f [--arg1: number, --arg2: string] {}
