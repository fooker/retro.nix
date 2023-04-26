{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "retroarch-database";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-database";
    hash = "sha256-x6D0jhyVfDX7FCW8PiILPc7FXen62h2u4fv5N8YPGTE=";
    rev = "v${version}";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "INSTALLDIR=$(PREFIX)/share/retroarch/database"
  ];

  dontBuild = true;

  meta = with lib; {
    description = "Libretro's database files";
    homepage = "https://libretro.com";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
