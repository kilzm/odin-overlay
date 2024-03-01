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
    dev-2023-10 = {
      hash = "sha256-ZKxTkqPjbr/xw1HJ8jWrN4R1i9tKrZT9AGWFHIhpC1E=";
      llvmPackages = prev.llvmPackages_14;
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

  release-pkgs = lib.mapAttrs' (version: attrs:
    lib.nameValuePair "odin-${version}"
    (odin-release { inherit version attrs; })) releases;

  odin-latest = odin-github {
    llvmPackages = prev.llvmPackages_17;
    version = "latest";
    rev = "master";
    hash = "sha256-9cweXSjNpXNGbL2DzkJ6jq9WpQA+geOZnT5KPFBsQE8=";
  };

  odin-sroa-pass = odin-github {
    llvmPackages = prev.llvmPackages_17;
    version = "sroa-pass";
    rev = "034aead9301305d41756ef3b5b9b60a88c95d825";
    hash = "sha256-okfcOlajq+r3oHH9zRHqaND4kIq3LWKYfEK7WTaI8hk=";
  };

  ols = prev.callPackage ./ols.nix { odin = odin-latest; };
in { odin-pkgs = release-pkgs // { inherit odin-sroa-pass odin-latest ols; }; }
