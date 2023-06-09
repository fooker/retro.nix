# Package for EmulationStation forked by RetroPie

{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, fetchpatch
, libGLU
, libGL
, SDL2
, freeimage
, freetype
, curl
, alsa-lib
, vlc
, rapidjson
, makeWrapper
, ... }:

stdenv.mkDerivation rec {
  pname = "emulationstation";
  version = "v2.11.2";

  src = fetchFromGitHub {
    owner = "RetroPie";
    repo = "EmulationStation";
    rev = version;
    sha256 = "sha256-J5h/578FVe4DXJx/AvpRnCIUpqBeFtmvFhUDYH5SErQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    libGLU
    libGL
    SDL2
    freeimage
    freetype
    curl
    alsa-lib
    vlc
    rapidjson
  ];

  postInstall = ''
    mkdir "$out/shared"
    cp -R "$src/resources" "$out/shared"
  '';

  postFixup = ''
    wrapProgram "$out/bin/emulationstation" \
      --chdir "$out/shared"
  '';
}