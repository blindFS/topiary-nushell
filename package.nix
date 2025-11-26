{
  stdenv,
  lib,
  runCommand,
  writeShellApplication,
  tree-sitter-nu ? fetchGit "https://github.com/nushell/tree-sitter-nu",
  topiary,
  nushell,
  callPackage,
}:
writeShellApplication (
  let
    libtree-sitter-nu = callPackage (
      {
        lib,
        stdenv,
      }:
      stdenv.mkDerivation (finalAttrs: {
        pname = "tree-sitter-nu";
        version = tree-sitter-nu.rev;

        src = tree-sitter-nu;

        makeFlags = [
          # The PREFIX var isn't picking up from stdenv.
          "PREFIX=$(out)"
        ];

        meta = with lib; {
          description = "A tree-sitter grammar for nu-lang, the language of nushell";
          homepage = "https://github.com/nushell/tree-sitter-nu";
          license = licenses.mit;
        };
      })
    ) { };

    extension =
      with stdenv;
      if isLinux then
        ".so"
      else if isDarwin then
        ".dylib"
      else
        throw "Unsupported system: ${system}";

    # Create a directory holding ALL runtime config files
    # This makes a single path for GC root.
    topiaryConfigDir = runCommand "topiary-nushell-config" { } ''
      local_config_dir="$out"

      # 1. Copy the nu.scm language directory
      mkdir -p $local_config_dir/languages
      cp ${./languages/nu.scm} $local_config_dir/languages/nu.scm

      cat > $local_config_dir/languages.ncl <<EOF
      {
        languages = {
          nu = {
            extensions = ["nu"],
            grammar.source.path = "${libtree-sitter-nu}/lib/libtree-sitter-nu${extension}",
          },
        },
      }
      EOF
    '';
  in
  {
    name = "topiary-nushell";
    runtimeInputs = [
      nushell
      topiary
    ];
    runtimeEnv = {
      TOPIARY_CONFIG_FILE = "${topiaryConfigDir}/languages.ncl";
      TOPIARY_LANGUAGE_DIR = "${topiaryConfigDir}/languages";
    };
    text = ''
      ${lib.getExe topiary} "$@"
    '';
  }
)
