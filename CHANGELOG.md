# Change Log

All style related breaking changes will be documented in this file.

### [eb107d7](<https://github.com/blindFS/topiary-nushell/commit/eb107d753c687311ce1f09f68963d482c3d4335b>) feat(style)!: +1 indentation level for multiline pipelines in assignment-like expressions

<details>

Related issue: [#43](https://github.com/blindFS/topiary-nushell/issues/43)

#### Before the change

```nushell
let config: path = $config
| default (
  $toplevel
  | path join .cargo nextest.toml
)
```

#### After the change

```nushell
let config: path = $config
  | default (
    $toplevel
    | path join .cargo nextest.toml
  )
```

</details>

### [1984133](https://github.com/blindFS/topiary-nushell/commit/1984133571fcf49e132d635b353c25000de7db2f) fix(style): leading/ending space in blocks, none in records

<details>

To match the [best practice guidance](https://www.nushell.sh/book/style_guide.html#one-line-format).

# Before the change

```nushell
let closure = {foo bar}
let record = { a:b c:d }
```

# After the change

```nushell
let closure = { foo bar }
let record = {a: b c: d}
```

</details>
