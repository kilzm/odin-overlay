{
  description = "Overlay for the Odin compiler";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs, flake-utils, }:
    let
      odin-overlay = import ./.;
      outputs = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ odin-overlay ];
          };
        in {
          packages = pkgs.odin-pkgs;
          overlays = rec {
            inherit odin-overlay;
            default = odin-overlay;
          };
          formatter = pkgs.nixfmt;
        });
    in outputs // { overlays.default = odin-overlay; };
}
