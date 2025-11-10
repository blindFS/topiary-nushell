const dir_preview_cmd = "eza --tree -L 3 --color=always {} | head -200"
const file_preview_cmd = "bat -n --color=always --line-range :200 {}"
const default_preview_cmd = "if ({} | path type) == 'dir'" + $' {($dir_preview_cmd)} else {($file_preview_cmd)}'
# TODO: r#''#r verbatim
const help_preview_cmd = "try {help {}} catch {'custom command or alias'}"
const external_tldr_cmd = "try {tldr -C {}} catch {'No doc yet'}"
const hybrid_help_cmd = ("Multiline
   string" +
  ($external_tldr_cmd | str replace '{}' '(foo)') +
  "another multiline
  string" +
  ($help_preview_cmd | str replace '{}' '(bar)')
)
mut  foo = 'foo bar'
$foo  += 'baz'
$foo  +=  r#'baz'#

# https://github.com/blindFS/topiary-nushell/issues/28
$'

(1)'
