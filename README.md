# Format nushell with Topiary

[![Build Status](https://img.shields.io/github/actions/workflow/status/blindfs/topiary-nushell/ci.yml?branch=main)](https://github.com/blindfs/topiary-nushell/actions)

* [Topiary](https://github.com/tweag/topiary): tree-sitter based uniform formatter
* This repo contains:
  * languages.ncl: configuration that enables nushell
  * nu.scm: tree-sitter query DSL that defines the behavior of the formatter for nushell
  * stand-alone tests written in nushell

## Status

* Supposed to work well with all language features of nushell v0.110
  * Except for some known issues of `tree-sitter-nu`

> [!NOTE]
>
> * There are corner cases where `tree-sitter-nu` would fail with parsing errors.  If you encounter any, feel free to report [at the parser side](https://github.com/nushell/tree-sitter-nu/issues).
> * If you encounter any style/format issue, please open an issue in this repo.
> * At this stage, the default style of nu-lang has no consensus yet, related breaking changes will be documented in [CHANGELOG.md](https://github.com/blindFS/topiary-nushell/blob/main/CHANGELOG.md).

## Quick Setup

> [!NOTE]
> This section is for nushell users who have little experience with topiary.
> If you are already an experienced topiary user, you can grab the necessary files in this repo and merge them into your topiary configuration in your own preferred way.

1. Install `topiary-cli` using whatever package-manager on your system (0.7.0+ required):

```nushell
# e.g. installing with cargo
cargo install topiary-cli
```

2. Set up topiary config:

Using `$env.XDG_CONFIG_HOME/topiary` is recommended for non-Windows users.

```nushell
mkdir ($env.XDG_CONFIG_HOME | path join topiary queries)
# languages.ncl goes in config root dir
http get https://raw.githubusercontent.com/blindFS/topiary-nushell/main/languages.ncl
  | save ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
# languages/nu.scm goes in config queries dir
http get https://raw.githubusercontent.com/blindFS/topiary-nushell/main/languages/nu.scm
  | save ($env.XDG_CONFIG_HOME | path join topiary queries nu.scm)
```

3. Setup environment variables (optional):

> [!WARNING]
> This is required if:
>
> 1. On Windows
> 2. The config files are in a location other than `$env.XDG_CONFIG_HOME/topiary`
>
> Take the [`format.nu`](https://github.com/blindFS/topiary-nushell/blob/main/format.nu) script in this repo as an example.

Add the following to your `env.nu`:

```nushell
# Set environment variables according to your topiary config path:
$env.TOPIARY_CONFIG_FILE = ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
$env.TOPIARY_LANGUAGE_DIR = ($env.XDG_CONFIG_HOME | path join topiary queries)
```

> [!WARNING]
> For Windows users, if something went wrong the first time you run the formatter,
> like compiling errors, you might need the following extra steps to make it work.

<details>
  <summary>Optional for Windows </summary>

1. Install the [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md).
2. Clone [tree-sitter-nu](https://github.com/nushell/tree-sitter-nu) somewhere and cd into it.
3. Build the parser manually with `tree-sitter build`.
4. Replace the `languages.ncl` file with something like:

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
  <summary>Using topiary-cli (recommended) </summary>
  
```nushell
# in-place formatting
topiary format script.nu

# stdin -> stdout
cat foo.nu | topiary format --language nu
```

</details>

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
        "command": "topiary",
        "arguments": ["format", "--language", "nu"]
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
