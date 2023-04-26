{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "retroarch-assets";
  version = "2023-04-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
    hash = "sha256-ALHh9QmxniJYiWVI8P0iByefRcCiDNx7xyIYzpWr1ek=";
    rev = "1d1bf42537696076a10d2c5c5f045d93a9788e62";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "INSTALLDIR=$(PREFIX)/share/retroarch/assets"
  ];

  dontBuild = true;

  meta = with lib; {
    description = "Libretro's database files";
    homepage = "https://libretro.com";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
