{ lib, llvmPackages, makeBinaryWrapper, libiconv, which, version, src, }:
let inherit (llvmPackages) stdenv;
in stdenv.mkDerivation {
  pname = "odin";
  inherit version src;

  nativeBuildInputs = [ makeBinaryWrapper which ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

  patchPhase = ''
    sed -i build_odin.sh \
      -e 's/^GIT_SHA=.*$/GIT_SHA=/' \
      -e 's/LLVM-C/LLVM/' \
      -e 's/framework System/lSystem/'
    patchShebangs build_odin.sh
  '';

  dontConfigure = true;

  buildFlags = [ "release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r ./{core,vendor,shared} $out/share
    cp -r ./base $out/share 2>/dev/null || :
    cp odin $out/bin
    wrapProgram $out/bin/odin \
      --prefix PATH : ${
        lib.makeBinPath (with llvmPackages; [ bintools llvm clang lld ])
      } \
      --set-default ODIN_ROOT $out/share

    runHook postInstall
  '';
}
