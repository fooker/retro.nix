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

  preferLocalBuild = true;
  allowSubstitutes = false;

  dontBuild = true;

  installPhase = ''
    cp -r $src $out
  '';

  meta = with lib; {
    description = "RetroArch core info files";
    homepage = "https://libretro.com";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
