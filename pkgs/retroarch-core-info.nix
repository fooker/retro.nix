{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "libretro-core-info";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    hash = "sha256-ALHh9QmxniJYiWVI8P0iByefRcCiDNx7xyIYzpWr1ek=";
    rev = "v${version}";
  };

  installPhase = ''
    cp -r $src $out
  '';

  dontBuild = true;

  meta = with lib; {
    description = "Libretro's database files";
    homepage = "https://libretro.com";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
