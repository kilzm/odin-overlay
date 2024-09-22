{ stdenv, makeBinaryWrapper, fetchFromGitHub, odin, }:
stdenv.mkDerivation {
  pname = "ols";
  version = "latest";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "b29789b7e5ccfdc358af53f7ae25eaa28bef9590";
    hash = "sha256-DNPUcbl8JstoQzt3YoTRqHWfNNw0vUfIjM5MQFwBY/M=";
  };

  buildInputs = [ odin ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postPatch = ''
    patchShebangs build.sh
    patchShebangs odinfmt.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./odinfmt.sh
    ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ols $out/bin/
    cp odinfmt $out/bin/
    wrapProgram $out/bin/ols --set-default ODIN_ROOT ${odin}/share

    runHook postInstall
  '';
}
