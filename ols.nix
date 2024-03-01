{ stdenv, makeBinaryWrapper, fetchFromGitHub, odin, }:
stdenv.mkDerivation {
  pname = "ols";
  version = "latest";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "acb232ac94f46d6c1b81378ab0be0c5b2f91a446";
    hash = "sha256-MzfhTHuvQT+Yw96EL3j8RiWz4M6l0PKpXQdCRbcD8Rc=";
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
