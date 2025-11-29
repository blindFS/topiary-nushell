#!/usr/bin/env -S nu --stdin

const script_path = path self .

# DEPRECATED. Migrate to `bin/topiary-nushell` (which supports being added to the system PATH variable).
# This `format.nu` script may be removed from the `topiary-nushell` repo in the future.
def main [
  --config_dir (-c): path # Root of the topiary-nushell repo, defaults to the parent directory of this script
  ...files: path # Files to format
]: [nothing -> nothing string -> string] {

  print -e "WARNING: This format.nu script is deprecated and may be removed in the future.\nMigrate to `bin/topiary-nushell`.\n"

  let config_dir = $config_dir | default $script_path
  $env.TOPIARY_CONFIG_FILE = ($config_dir | path join languages.ncl)
  $env.TOPIARY_LANGUAGE_DIR = ($config_dir | path join languages)

  if ($files | is-not-empty) {
    topiary format ...$files
  } else {
    topiary format --language nu
  }
}
