{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "retroarch-tools";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    hash = "sha256-70PG8EMN9E9+SOmQj2NyI6jSq0UTd/+zQaM5flgNI8Y=";
    rev = "v${version}";
  };

  sourceRoot = "source/libretro-db";

  postUnpack = ''
    chmod -R u+w -- source
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  installPhase = ''
    mkdir -p "$out/bin"

    cp c_converter dat_converter libretrodb_tool "$out/bin"
  '';

  meta = with lib; {
    description = "Libretro's database files";
    homepage = "https://libretro.com";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
