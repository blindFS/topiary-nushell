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
            rev = "f4793e3809bb84e78dee260b47085d8203a58d88";
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
