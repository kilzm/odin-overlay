#  Odin Compiler Overlay
This flake packages versions of the [Odin](https://github.com/odin-lang/Odin) compiler as well as the [Odin Language Server](https://github.com/DanielGavin/ols).
You either use the packages directly through the flake's `packages` output or apply the default overlay.
The overlay adds an attribute set `odin-pkgs` which includes all packages.
To view the available packages:
```bash
nix flake show github:kilzm/odin-overlay
```

Odin is built with the latest compatible version of LLVM.
