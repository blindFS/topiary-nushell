use std assert

const script_pwd = path self .

def run_ide_check [
  file: path
] {
  nu --ide-check 9999 $file
  | lines
  | each { $in | from json }
  | flatten
  | where severity? == Error
  | reject start end
}

def print_progress [
  ratio: float
  length: int = 20
] {
  let done = '▓'
  let empty = '░'
  let count = [1 (($ratio * $length) | into int)] | math max
  (
    print -n
    ('' | fill -c $done -w $count)
    ('' | fill -c $empty -w ($length - $count))
    ($ratio * 100 | into string --decimals 0) %
  )
}

# Test the topiary formatter with all nu files within a directory
# each script should pass the idempotent check as well as the linter
export def test_format [
  path: path # path to test
] {
  $env.TOPIARY_CONFIG_FILE = ($script_pwd | path join languages.ncl)
  $env.TOPIARY_LANGUAGE_DIR = ($script_pwd | path join languages)
  let files = if ($path | path type) == 'file' {
    [$path]
  } else {
    glob $'($path | str trim -r -c '/')/**/*.nu'
  }
  let len = $files | length
  if $len == 0 {
    print $"No nu scripts found in (ansi yellow)($path).(ansi reset)"
    return
  }
  let all_passed = 1..$len | par-each {|i|
      let file = $files | get ($i - 1)
      let target = $"(random uuid).nu"
      if ($i mod 10) == 0 {
        print -n $"(ansi -e '1000D')"
        print_progress ($i / $len)
      }
      let failed = try {
        cp $file $target
        let err_before = run_ide_check $target
        topiary format $target
        let err_after = run_ide_check $target
        assert ($err_before == $err_after)
        true
      } catch {
        print $"(ansi red)Error detected: (ansi yellow)($file)(ansi reset)"
        false
      }
      rm $target
      $failed
    }
    | all { $in }
  if $all_passed {
    print -n $"(ansi -e '1000D')"
    print $"(ansi green)All nu scripts successfully passed the check, but style issues are still possible.(ansi reset)"
  }
}
