final: prev:
let
  inherit (prev) lib;
  odin-release = { version, attrs, }:
    prev.callPackage ./odin.nix {
      inherit version;
      inherit (attrs) llvmPackages;
      src = prev.fetchzip {
        url =
          "https://github.com/odin-lang/Odin/archive/refs/tags/${version}.zip";
        inherit (attrs) hash;
      };
    };

  releases = {
    dev-2024-04a = {
      hash = "sha256-jFENpWUosNNTctYiHdKqDg7ENAoEtigz87pTfYJDj5Q=";
      llvmPackages = prev.llvmPackages_17;
    };
    dev-2024-04 = {
      hash = "sha256-nPf3ARUUiHSKpKh+jDm78eM/9c7fbAl0xsjb8iotsgI=";
      llvmPackages = prev.llvmPackages_17;
    };
    dev-2024-03 = {
      hash = "sha256-oK5OcWAZy9NVH19oep6QU4d5qaiO0p+d9FvxDIrzFLU=";
      llvmPackages = prev.llvmPackages_17;
    };
    dev-2024-02 = {
      hash = "sha256-v9A0+kgREXALhnvFYWtE0+H4L7CYnyje+d2W5+/ZvHA=";
      llvmPackages = prev.llvmPackages_17;
    };
    dev-2024-01 = {
      hash = "sha256-ufIpnibY7rd76l0Mh+qXYXkc8W3cuTJ1cbmj4SgSUis=";
      llvmPackages = prev.llvmPackages_17;
    };
    dev-2023-12 = {
      hash = "sha256-XFaXs9zNQ/53QprF8pM2pOtiB0nGu8mGbBozNl0EMyA=";
      llvmPackages = prev.llvmPackages_17;
    };
    dev-2023-11 = {
      hash = "sha256-5plcr+j9aFSaLfLQXbG4WD1GH6rE7D3uhlUbPaDEYf8=";
      llvmPackages = prev.llvmPackages_17;
    };
  };

  odin-github = { rev, version, hash, llvmPackages, }:
    prev.callPackage ./odin.nix {
      inherit version llvmPackages;
      src = prev.fetchFromGitHub {
        owner = "odin-lang";
        repo = "Odin";
        inherit rev hash;
      };
    };

  patch-sroa = pkg: pkg.overrideAttrs (old: { patches = (old.patches or []) ++ [ ./patches/add-removed-passes.patch ]; });

  release-pkgs = lib.mapAttrs' (version: attrs:
    lib.nameValuePair "odin-${version}"
    (odin-release { inherit version attrs; })) releases;

  release-pkgs-sroa = lib.mapAttrs' (name: pkg:
    lib.nameValuePair "${name}-sroa"
    (patch-sroa pkg)) release-pkgs;

  odin-latest = odin-github {
    llvmPackages = prev.llvmPackages_17;
    version = "latest";
    rev = "17a01a81d812793ee494d46885e6316c7cdd447e";
    hash = "sha256-My7B1D5jvur9ot8xo/Z3G9lGQU1uZw22/H7AQ2Y+p8E=";
  };

  odin-latest-sroa = patch-sroa odin-latest;

  ols = prev.callPackage ./ols.nix { odin = release-pkgs.odin-dev-2024-04a; };
in { odin-pkgs = release-pkgs // release-pkgs-sroa // { inherit odin-latest odin-latest-sroa ols; }; }
