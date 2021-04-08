{ lib, stdenv, fetchFromGitHub, Foundation, readline }:

with lib;

stdenv.mkDerivation rec {
  pname = "premake5";
  version = "5.0.0-alpha15";

  src = fetchFromGitHub {
    owner = "premake";
    repo = "premake-core";
    rev = "v${version}";
    sha256 = "0cdwc7qbxyprgvgfk81xs3g19fvmkxgq2k58f65kbwx40ymn3xzh";
  };

  buildInputs = optionals stdenv.isDarwin [ Foundation readline ];

  buildPhase =
    if stdenv.isDarwin then ''
       make -f Bootstrap.mak osx
    '' else ''
       make -f Bootstrap.mak linux
    '';

  installPhase = ''
    install -Dm755 bin/release/premake5 $out/bin/premake5
  '';

  premake_cmd = "premake5";
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://premake.github.io";
    description = "A simple build configuration and project generation tool using lua";
    license = licenses.bsd3;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [ arvindpunk ];
  };
}
