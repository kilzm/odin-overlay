{ stdenv, makeBinaryWrapper, fetchFromGitHub, odin, }:
stdenv.mkDerivation {
  pname = "ols";
  version = "latest";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "09f865e685f8ebddaf994e51baeabed795e7f849";
    hash = "sha256-JdKmXMyRZCf6UYo5sKmiIaeZNgnbUm5ALP39tf6z36w=";
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
