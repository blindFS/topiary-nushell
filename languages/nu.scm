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
] @leaf

;; keep empty lines
(_) @allow_blank_line_before

[
  ":"
  ";"
  "do"
  "if"
  "match"
  "try"
  "while"
  (env_var)
] @append_space

[
  "="
  (match_guard)
  (short_flag)
  (long_flag)
] @prepend_space

;; FIXME: temp workaround for the whitespace issue
(short_flag "=" @prepend_antispace)
(long_flag "=" @prepend_antispace)
(param_value "=" @append_space)

(assignment
  opr: _
  rhs: (pipeline
    (pipe_element
      (val_string
        (raw_string_begin)
      )
    )
  ) @prepend_space
)

(
  "="
  .
  (pipeline
    (pipe_element
      (val_string
        (raw_string_begin)
      )
    )
  ) @prepend_space
)

[
  "->"
  "=>"
  "alias"
  "as"
  "catch"
  "const"
  "def"
  "else"
  "error"
  "export"
  "export-env"
  "extern"
  "for"
  "hide"
  "hide-env"
  "in"
  "let"
  "loop"
  "make"
  "module"
  "mut"
  "new"
  "overlay"
  "return"
  "source"
  "source-env"
  "use"
  "where"
] @prepend_space @append_space

(pipeline
  "|" @append_space @prepend_input_softline
)

;; add spaces to left & right sides of operators
(expr_binary
  opr: _ @append_input_softline @prepend_input_softline
)

(assignment opr: _ @prepend_space)

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

(overlay_hide
  overlay: _ @prepend_space
)

;; FIXME: temp workaround for the whitespace issue
(hide_env
  [
    (short_flag)
    (long_flag)
  ] @append_antispace
  .
  (_)
)

(hide_env
  (identifier) @append_space
  .
  (identifier)
)

(hide_mod
  (_) @append_space
  .
  (_)
)

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

;;; change line happens after || for closure
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
  type: _ @append_space
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

(block
  "{" @append_space
  "}" @prepend_space
)

(val_closure
  (_) @append_begin_scope
  .
  (_) @prepend_end_scope @prepend_input_softline
  (#scope_id! "consecutive_scope")
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
)

(ctrl_do (_) @prepend_input_softline)

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

;; match_arm
(val_list
  entry: _ @append_space
  .
  entry: _ @prepend_spaced_softline
)

(val_table
  row: _ @prepend_spaced_softline
)

(val_record
  entry: (record_entry) @append_space
  .
  entry: (record_entry) @prepend_spaced_softline
)

(record_body
  entry: (record_entry) @append_space
  .
  entry: (record_entry) @prepend_spaced_softline
)

(collection_type
  type: _ @append_delimiter
  .
  key: _ @prepend_space
  (#delimiter! ",")
)
