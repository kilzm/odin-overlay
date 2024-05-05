{ stdenv, makeBinaryWrapper, fetchFromGitHub, odin, }:
stdenv.mkDerivation {
  pname = "ols";
  version = "latest";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "82db36fdbf44236dd0e2bad69ca8402c4c8942fb";
    hash = "sha256-82OjF0HhtNu8NfbtEZcNwGqkQU7IWcdlmhl+2jJatnk=";
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
