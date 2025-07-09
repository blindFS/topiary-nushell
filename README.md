# Format nushell with Topiary

[![Build Status](https://img.shields.io/github/actions/workflow/status/blindfs/topiary-nushell/ci.yml?branch=main)](https://github.com/blindfs/topiary-nushell/actions)

* [Topiary](https://github.com/tweag/topiary): tree-sitter based uniform formatter
* This repo contains:
  * languages.ncl: configuration that enables nushell
  * nu.scm: tree-sitter query DSL that defines the behavior of the formatter for nushell
  * stand-alone tests written in nushell

## Status

* Supposed to work well with all language features of nushell v0.105

> [!NOTE]
>
> * There're corner cases where `tree-sitter-nu` would fail with parsing errors, if you encounter them, please open an issue [there](https://github.com/nushell/tree-sitter-nu).
> * If you encounter any style/format issue, please report in this repo, any feedback is appreciated.

## Setup

1. Install topiary-cli using whatever package-manager on your system (0.6.1+ required)

```nushell
# e.g. installing with cargo
cargo install --git https://github.com/tweag/topiary topiary-cli
```

2. Clone this repo somewhere

```nushell
# e.g. to `$env.XDG_CONFIG_HOME/topiary`
git clone https://github.com/blindFS/topiary-nushell ($env.XDG_CONFIG_HOME | path join topiary)
```

3. Setup environment variables (Optional)

> [!WARNING]
> This is required if you want to do the formatting via vanilla topiary-cli, like in the neovim/helix settings below.
>
> While the [`format.nu`](https://github.com/blindFS/topiary-nushell/blob/main/format.nu) script in this repo just wraps that for you.

```nushell
# Set environment variables according to the path of the clone
$env.TOPIARY_CONFIG_FILE = ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
$env.TOPIARY_LANGUAGE_DIR = ($env.XDG_CONFIG_HOME | path join topiary languages)
```

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

<details>
  <summary>Using the <a href="https://github.com/blindFS/topiary-nushell/blob/main/format.nu">format.nu</a> wrapper </summary>
  
```markdown
Helper to run topiary with the correct environment variables for topiary-nushell

Usage:
  > format.nu {flags} ...(files)

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
  > bat foo.nu | format.nu

  Format files (in-place replacement)
  > format.nu foo.nu bar.nu

  Path overriding
  > format.nu -c /path/to/topiary-nushell foo.nu bar.nu
```

</details>

<details>
  <summary>Using topiary-cli </summary>
  
```nushell
# in-place formatting
topiary format script.nu
# stdin -> stdout
cat foo.nu | topiary format --language nu
```

</details>

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
        command = "topiary",
        args = { "format", "--language", "nu" },
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
formatter = { command = "topiary", args = ["format", "--language", "nu"] }
```

</details>

<details>
  <summary>Zed </summary>

```json
"languages": {
  "Nu": {
    "formatter": {
      "external": {
        "command": "/path-to-the-clone/format.nu"
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
