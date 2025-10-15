;; leaf nodes are left intact
[
  (cell_path)
  (comment)
  (shebang)
  (unquoted)
  (val_binary)
  (val_bool)
  (val_date)
  (val_duration)
  (val_filesize)
  (val_nothing)
  (val_number)
  (val_string)
  (val_variable)
  (cmd_identifier)
  (identifier)
  (path)
] @leaf

;; TODO: new feature of the next topiary release
;; (unescaped_interpolated_content) @keep_whitespaces

;; keep empty lines
(_) @allow_blank_line_before

[
  ":"
  ";"
  "if"
  "match"
  "try"
  "while"
  (env_var)
] @append_space

[
  "="
  "->"
  "=>"
  "alias"
  "catch"
  "const"
  "def"
  "else"
  "export"
  "export-env"
  "extern"
  "for"
  "in"
  "let"
  "loop"
  "module"
  "mut"
  "use"
  "where"
  (match_guard)
] @prepend_space @append_space

(pipeline
  "|" @append_space @prepend_input_softline
)

;; add spaces to left & right sides of operators
(expr_binary
  opr: _ @append_input_softline @prepend_input_softline
)

(assignment opr: _ @prepend_space @append_space)

(where_predicate
  opr: _ @append_input_softline @prepend_input_softline
)

;; special flags
(
  [
    (short_flag)
    (long_flag)
  ] @append_space
  .
  (_)
)
(short_flag "=" @prepend_antispace @append_antispace)
(long_flag "=" @prepend_antispace @append_antispace)
(env_var "=" @prepend_antispace @append_antispace)

;; indentation
[
  "["
  "("
  "...("
  "...["
  "...{"
] @append_indent_start @append_empty_softline

[
  "]"
  "}"
  ")"
] @prepend_indent_end @prepend_empty_softline

;; change line happens after || for closure
"{" @append_indent_start
(
  "{" @append_empty_softline
  .
  (parameter_pipes)? @do_nothing
)

;; space/newline between parameters
(parameter_pipes
  (
    (parameter) @append_space
    .
    (parameter)
  )?
) @append_space @append_spaced_softline

(parameter_bracks
  (parameter) @append_space
  .
  (parameter) @prepend_empty_softline
)

(parameter_parens
  (parameter) @append_space
  .
  (parameter) @prepend_empty_softline
)

(parameter
  param_long_flag: _? @prepend_space
  .
  flag_capsule: _? @prepend_space
)

(parameter
  "," @delete
)

;; attributes
(attribute
  (attribute_identifier)
  (_)? @prepend_space
) @append_hardline

(attribute_list
  ";" @delete @append_hardline
)

;; declarations
(decl_def
  (long_flag)? @prepend_space @append_space
  quoted_name: _? @prepend_space @append_space
  unquoted_name: _? @prepend_space @append_space
  (returns)?
  (block) @prepend_space
)

(returns
  ":"? @do_nothing
) @prepend_space

(returns
  type: _ @append_spaced_softline
  .
  type: _
)

(decl_use (_) @prepend_space)
(decl_extern (_) @prepend_space)
(decl_module (_) @prepend_space)

;; newline
(comment) @prepend_input_softline @append_hardline

;; TODO: pseudo scope_id to cope with
;; https://github.com/tree-sitter/tree-sitter/discussions/3967
(nu_script
  (_) @append_begin_scope
  .
  (_) @prepend_end_scope @prepend_input_softline
  (#scope_id! "consecutive_scope")
)

(block
  (_) @append_begin_scope
  .
  (_) @prepend_end_scope @prepend_input_softline
  (#scope_id! "consecutive_scope")
)

(val_closure
  (_) @append_begin_scope
  .
  (_) @prepend_end_scope @prepend_input_softline
  (#scope_id! "consecutive_scope")
)

(block
  "{" @append_space
  "}" @prepend_space
)

;; HACK: temporarily disable formatting after special comment
;; abuse capture `@do_nothing` for the predicate
(nu_script
  (comment) @do_nothing
  .
  (_) @leaf
  (#match? @do_nothing "topiary: disable")
)

(block
  (comment) @do_nothing
  .
  (_) @leaf
  (#match? @do_nothing "topiary: disable")
)

(val_closure
  (comment) @do_nothing
  .
  (_) @leaf
  (#match? @do_nothing "topiary: disable")
)

(val_closure
  "{" @append_space
  .
  (parameter_pipes)? @do_nothing
)

(val_closure "}" @prepend_space)

;; control flow
(ctrl_if
  "if" @append_space
  condition: _ @append_space
  then_branch: _
  "else"? @prepend_input_softline
)

(ctrl_for
  "for" @append_space
  "in" @prepend_space @append_space
  body: _ @prepend_space
)

(ctrl_while
  "while" @append_space
  condition: _ @append_space
)

(ctrl_match
  "match" @append_space
  scrutinee: _? @append_space
  (match_arm)? @prepend_spaced_softline
  (default_arm)? @prepend_spaced_softline
  "}"? @prepend_spaced_softline
)

(match_pattern "|" @prepend_spaced_softline @append_space )

;; data structures
(command_list
  [
    (cmd_identifier)
    (val_string)
  ] @append_space @prepend_spaced_softline
)

(command
  flag: _? @prepend_input_softline
  arg_str: _? @prepend_input_softline
  arg_spread: _? @prepend_input_softline
  arg: _? @prepend_input_softline
)

(redirection
  file_path: _? @prepend_input_softline
) @prepend_input_softline

(list_body
  entry: _ @append_space
  .
  entry: _ @prepend_spaced_softline
)

(record_body
  entry: _ @append_space
  .
  entry: _ @prepend_spaced_softline
)

;; match_arm
(val_list
  (list_body)
  .
  rest: _ @prepend_spaced_softline
)

(val_table
  row: _ @prepend_spaced_softline
)

;; type notation
(collection_type
  [
    type: _
    key: _
  ] @append_delimiter
  .
  key: _ @prepend_space
  (#delimiter! ",")
)

(composite_type
  type: _ @append_delimiter
  .
  type: _ @prepend_space
  (#delimiter! ",")
)
