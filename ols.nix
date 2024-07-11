{ stdenv, makeBinaryWrapper, fetchFromGitHub, odin, }:
stdenv.mkDerivation {
  pname = "ols";
  version = "latest";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "f206288b0072a57e2dd2dda6a12a748a756ffbd7";
    hash = "sha256-H87dX7xy82ZJmpLlZYEse8aBtlXQapDNpQ+mScH4FdU=";
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
