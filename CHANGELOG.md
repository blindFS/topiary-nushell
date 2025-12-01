# Change Log

All style related breaking changes will be documented in this file.

### [eb107d7](<https://github.com/blindFS/topiary-nushell/commit/eb107d753c687311ce1f09f68963d482c3d4335b>) feat(style)!: +1 indentation level for multiline pipelines in assignment-like expressions

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
