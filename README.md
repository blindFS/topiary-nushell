# Format nushell with Topiary

[![Build Status](https://img.shields.io/github/actions/workflow/status/blindfs/topiary-nushell/ci.yml?branch=main)](https://github.com/blindfs/topiary-nushell/actions)

* [Topiary](https://github.com/tweag/topiary): tree-sitter based uniform formatter
* This repo contains:
  * `bin/topiary-nushell` wrapper for `topiary` that formats nushell files
  * `languages.ncl`: configuration that enables nushell
  * `languages/nu.scm`: tree-sitter query DSL that defines the behavior of the formatter for nushell
  * `format.nu`: deprecated version of `bin/topiary-nushell`
  * stand-alone tests written in nushell

## Status

* Supposed to work well with all language features of nushell v0.108
  * Except for some known issues of `tree-sitter-nu`

> [!NOTE]
>
> * There're corner cases where `tree-sitter-nu` would fail with parsing errors, if you encounter any, feel free to report [at the parser side](https://github.com/nushell/tree-sitter-nu/issues).
> * If you encounter any style/format issue, please report in this repo.

## Setup

1. Install topiary-cli using whatever package-manager on your system (0.7.0+ required)

```nushell
# e.g. installing with cargo
cargo install topiary-cli
```

2. Clone this repo somewhere

```nushell
cd ~ # Replace `~` with wherever you'd like this repo to live
git clone https://github.com/blindFS/topiary-nushell
```

3. Add the `topiary-nushell/bin` folder to your PATH environment variable

> [!WARNING]
> For windows users, if something went wrong the first time you run the formatter,
> like compiling errors, you might need the following extra steps to make it work.

<details>
  <summary>Optional for Windows </summary>

1. Install the [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md).
2. Clone [tree-sitter-nu](https://github.com/nushell/tree-sitter-nu) somewhere and cd into it.
3. Build the parser manually with `tree-sitter build`.
4. Replace the `languages.ncl` file in this repo with something like:

```ncl
{
  languages = {
    nu = {
      extensions = ["nu"],
      grammar.source.path = "C:/path/to/tree-sitter-nu/nu.dll",
      symbol = "tree_sitter_nu",
    },
  },
}
```

</details>

## Usage

```markdown
Wrapper for `topiary` that formats `nushell` files

Usage:
  > topiary-nushell {flags} ...(files)

Flags:
  -c, --config_dir <path>: Root of the topiary-nushell repo, defaults to the parent directory of this script
  -h, --help: Display the help message for this command

Parameters:
  ...files <path>: Files to format

Input/output types:
  ╭───┬─────────┬─────────╮
  │ # │  input  │ output  │
  ├───┼─────────┼─────────┤
  │ 0 │ nothing │ nothing │
  │ 1 │ string  │ string  │
  ╰───┴─────────┴─────────╯

Examples:
  Read from stdin
  > bat foo.nu | topiary-nushell

  Format files (in-place replacement)
  > topiary-nushell foo.nu bar.nu

  Path overriding
  > topiary-nushell -c /path/to/topiary-nushell foo.nu bar.nu
```

### Locally Disable Formatting for Certain Expression

If you don't like the formatted output of certain parts of your code,
you can choose to disable it locally with a preceding `topiary: disable` comment:

```nushell
...
# topiary: disable
let foo = [foo, bar
  baz, ]
...
```

This will keep the let assignment as it is while formatting the rest of the code.

> [!NOTE]
> We do recommend reporting code style issues before resorting to this workaround.

## Editor Integration

<details>
  <summary>Neovim </summary>
  Format on save with <a href="https://github.com/stevearc/conform.nvim">conform.nvim</a>:

```lua
-- lazy.nvim setup
{
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  event = "VeryLazy",
  opts = {
    formatters_by_ft = {
      nu = { "topiary_nu" },
    },
    formatters = {
      topiary_nu = {
        command = "topiary-nushell",
      },
    },
  },
},
```

</details>

<details>
  <summary>Helix </summary>

To format on save in Helix, add this configuration to your `helix/languages.toml`.

```toml
[[language]]
name = "nu"
auto-format = true
formatter = { command = "topiary-nushell" }
```

</details>

<details>
  <summary>Zed </summary>

```json
"languages": {
  "Nu": {
    "formatter": {
      "external": {
        "command": "topiary-nushell"
      }
    },
    "format_on_save": "on"
  }
}
```

</details>

## Contribute

> [!IMPORTANT]
> Help to find format issues with following method
> (dry-run, detects parsing/idempotence/semantic breaking):

```nushell
source toolkit.nu
test_format <root-path-of-your-nushell-scripts>
```
