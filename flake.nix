{
  description = "Ansible environment for hl-playbooks";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              python3Packages = prev.python3Packages.overrideScope (
                self: super: {
                  # Temporary workaround for https://github.com/NixOS/nixpkgs/issues/400373
                  mocket = super.mocket.overridePythonAttrs (old: {
                    doCheck = false;
                    checkPhase = ''
                      echo "Skipping tests for mocket"
                    '';
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.typing-extensions ];
                  });
                }
              );
            })
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.ansible
            pkgs.ansible-lint
          ];
        };
      }
    );
}
