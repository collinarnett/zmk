{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zephyr.url = "github:zephyrproject-rtos/zephyr";
    zephyr.flake = false;
    mach-nix.url = "github:DavHau/mach-nix";
  };
  outputs = { self, nixpkgs, flake-utils, zephyr, mach-nix }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python-pkgs = mach-nix.lib.${system}.mkPython {
          requirements =
            builtins.readFile "${zephyr}/scripts/requirements-base.txt";
        };
      in with pkgs; {
        devShells.default = mkShell {
          buildInputs =
            [ cmake ccache ninja dtc dfu-util gcc-arm-embedded python-pkgs ];
          shellHook = ''
                export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
            export GNUARMEMB_TOOLCHAIN_PATH=${pkgs.gcc-arm-embedded}
          '';
        };
      });

}
