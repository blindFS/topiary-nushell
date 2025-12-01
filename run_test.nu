#!/usr/bin/env nu

use std assert

const temp_file = 'test/temp.nu'
let files = glob test/input_*.nu

$env.TOPIARY_CONFIG_FILE = (pwd | path join languages.ncl)
$env.TOPIARY_LANGUAGE_DIR = (pwd | path join languages)

def main [
  --update (-u) # force updating `expected_xxx` files
] {
  for f in $files {
    print $"(ansi green)Testing: (ansi yellow)($f)(ansi reset)"
    cp $f $temp_file
    topiary format $temp_file
    let expected_file = $f | str replace --regex '/input_' '/expected_'
    try {
      if ((which delta) | is-empty) {
        assert ((open $temp_file) == (open $expected_file))
      } else {
        delta $temp_file $expected_file --paging never
      }
    } catch {
      if $update and (
        [yes no]
        | input list --index --fuzzy $"Update expected results in file (
          $expected_file
          | path basename
        )?"
      ) == 0 {
        cp $temp_file $expected_file
      } else {
        exit 1
      }
    }
    rm $temp_file
  }
}
