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

  releases-llvm18 = let llvmPackages = prev.llvmPackages_18; in {
    dev-2024-09 = {
      hash = "sha256-rbKaGj4jwR+SySt+XJ7K9rtpQsL60IKJ55/1uNkVE1U=";
      inherit llvmPackages;
    };
    dev-2024-08 = {
      hash = "sha256-aoyi0ah5Jp2FDHT+VVQi8Mnz4cmLVuxS+lWZeQ0ilQY=";
      inherit llvmPackages;
    };
    dev-2024-07 = {
      hash = "sha256-FeiVTLwgP0x1EZqqiYkGbKALhZWC4xE6a/3PPcEElAc=";
      inherit llvmPackages;
    };
    dev-2024-06 = {
      hash = "sha256-Ba+244L855y+XzLcaf1fgQhHVDv2Q77GPapRAYmCQfg=";
      inherit llvmPackages;
    };
    dev-2024-05 = {
      hash = "sha256-JGTC+Gi5mkHQHvd5CmEzrhi1muzWf1rUN4f5FT5K5vc=";
      inherit llvmPackages;
    };
  };

  releases-llvm17 = let llvmPackages = prev.llvmPackages_17; in {
    dev-2024-04a = {
      hash = "sha256-jFENpWUosNNTctYiHdKqDg7ENAoEtigz87pTfYJDj5Q=";
      inherit llvmPackages;
    };
    dev-2024-04 = {
      hash = "sha256-nPf3ARUUiHSKpKh+jDm78eM/9c7fbAl0xsjb8iotsgI=";
      inherit llvmPackages;
    };
    dev-2024-03 = {
      hash = "sha256-oK5OcWAZy9NVH19oep6QU4d5qaiO0p+d9FvxDIrzFLU=";
      inherit llvmPackages;
    };
    dev-2024-02 = {
      hash = "sha256-v9A0+kgREXALhnvFYWtE0+H4L7CYnyje+d2W5+/ZvHA=";
      inherit llvmPackages;
    };
    dev-2024-01 = {
      hash = "sha256-ufIpnibY7rd76l0Mh+qXYXkc8W3cuTJ1cbmj4SgSUis=";
      inherit llvmPackages;
    };
    dev-2023-12 = {
      hash = "sha256-XFaXs9zNQ/53QprF8pM2pOtiB0nGu8mGbBozNl0EMyA=";
      inherit llvmPackages;
    };
    dev-2023-11 = {
      hash = "sha256-5plcr+j9aFSaLfLQXbG4WD1GH6rE7D3uhlUbPaDEYf8=";
      inherit llvmPackages;
    };
  };

  patch-sroa = pkg: pkg.overrideAttrs (old: { patches = (old.patches or []) ++ [ ./patches/add-removed-passes.patch ]; });

  release-pkgs-llvm17 = lib.mapAttrs' (version: attrs:
    lib.nameValuePair "odin-${version}"
    (odin-release { inherit version attrs; })) releases-llvm17;

  release-pkgs-sroa-llvm17 = lib.mapAttrs' (name: pkg:
    lib.nameValuePair "${name}-sroa"
    (patch-sroa pkg)) release-pkgs-llvm17;

  # These releases enable sroa again
  release-pkgs-llvm18 = lib.mapAttrs' (version: attrs:
    lib.nameValuePair "odin-${version}"
    (odin-release { inherit version attrs; })) releases-llvm18;

  odin-latest = prev.callPackage ./odin.nix {
    version = "latest";
    src = prev.fetchFromGitHub {
      owner = "odin-lang";
      repo = "Odin";
      rev = "c1264c2a798b94561dd7dbfa627c5d1555258442";
      hash = "sha256-RNSFbdifRkokv1JIjABWfGEXtb3kSg1Ps2Pv68YzyDA=";
    };
    llvmPackages = prev.llvmPackages_18;
    pkgs = prev.pkgs;
  };

  ols = prev.callPackage ./ols.nix { odin = odin-latest; };
in { odin-pkgs = release-pkgs-llvm17 // release-pkgs-sroa-llvm17 // release-pkgs-llvm18 // { inherit ols odin-latest; }; }
