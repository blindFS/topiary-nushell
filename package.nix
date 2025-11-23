{
  stdenv,
  lib,
  writeShellApplication,
  tree-sitter-nu ? fetchGit "https://github.com/nushell/tree-sitter-nu",
  topiary,
  nushell,
  writeText,
  callPackage,
}:
writeShellApplication (let
  libtree-sitter-nu = callPackage ({
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
    })) {};
in {
  name = "topiary-nushell";
  runtimeInputs = [nushell topiary];
  runtimeEnv = let
    extension = with stdenv;
      if isLinux
      then ".so"
      else if isDarwin
      then ".dylib"
      else throw "Unsupported system: ${system}";
  in {
    TOPIARY_CONFIG_FILE = writeText "languages.ncl" ''
      {
        languages = {
          nu = {
            extensions = ["nu"],
            grammar.source.path = "${libtree-sitter-nu}/lib/libtree-sitter-nu${extension}",
          },
        },
      }
    '';
    TOPIARY_LANGUAGE_DIR = ./languages;
  };
  text = ''
    ${lib.getExe topiary} "$@"
  '';
})
