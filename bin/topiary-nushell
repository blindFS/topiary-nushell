#!/usr/bin/env -S nu --stdin

const script_path = path self .

# Helper to run topiary with the correct environment variables for topiary-nushell
@example "Read from stdin" { bat foo.nu | format.nu }
@example "Format files (in-place replacement)" { format.nu foo.nu bar.nu }
@example "Path overriding" { format.nu -c /path/to/topiary-nushell foo.nu bar.nu }
def main [
  --config_dir (-c): path # Root of the topiary-nushell repo, defaults to the parent directory of this script
  ...files: path # Files to format
]: [nothing -> nothing string -> string] {
  let config_dir = $config_dir | default $script_path
  $env.TOPIARY_CONFIG_FILE = ($config_dir | path join languages.ncl)
  $env.TOPIARY_LANGUAGE_DIR = ($config_dir | path join languages)

  if ($files | is-not-empty) {
    topiary format ...$files
  } else {
    topiary format --language nu
  }
}
