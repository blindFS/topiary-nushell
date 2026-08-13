{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-darwin"];
    buildEachSystem = output: map output systems;
    buildAllSystems = output: (
      builtins.foldl' nixpkgs.lib.recursiveUpdate {} (buildEachSystem output)
    );
  in
    buildAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages.${system} = {
        topiary-nushell = pkgs.callPackage ./package.nix {
          tree-sitter-nu = fetchGit {
            url = "https://github.com/nushell/tree-sitter-nu";
            rev = "64613ef22f4116862d7997939c8d1794ceb1f856";
          };
        };
        default = self.packages.${system}.topiary-nushell;
      };
      apps.${system} = {
        topiary-nushell = {
          type = "app";
          program = "${pkgs.lib.getExe self.packages.${system}.topiary-nushell}";
          meta = {
            description = "Topiary with NuShell support";
          };
        };
        default = self.apps.${system}.topiary-nushell;
      };
    });
}
