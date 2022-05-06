{
  description = "version-utils";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # Proivdes legacy compatibility for nix-shell
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    # Provides some nice helpers for multiple system compatibility
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    # Calls the provided function for each "default system", which
    # is the standard set.
    flake-utils.lib.eachDefaultSystem
      (system:
        # instantiate the package set for the supported system, with our
        # rust overlay
        let pkgs = import nixpkgs {
          inherit system;
        };
        in
        # "unpack" the pkgs attrset into the parent namespace
        with pkgs;
        {
          devShell = mkShell {
            # Packages required for development.
            buildInputs = [
              bashInteractive
              python39Full
              python39Packages.pytest
              python39Packages.pytest-cov
              python39Packages.setuptools
              python39Packages.twine
              python39Packages.wheel
              coreutils
              gnumake
            ];
          };
        });
}
