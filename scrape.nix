# Scrapes a directory of games and build a list of games for use in `config.retro.games`.
# The provided games directory must contain sub-directories for each system which contains the games.

{ lib
, runCommandLocal
, fetchFromGitHub
, jq
, rhash
, callPackage
, gamesDir # Path to the games directory
, ... }:

with lib;

let
  retroarch-tools = callPackage ./pkgs/retroarch-tools.nix { };
  retroarch-database = callPackage ./pkgs/retroarch-database.nix { };

  retroarch-thumbnails = fetchFromGitHub {
    owner = "libretro-thumbnails";
    repo = "libretro-thumbnails";
    hash = "sha256-O1SZZjamFaJkVR+/nLGheCjWufXGupwqLyYT7p4zHmE=";
    rev = "cb55065d6bf3ee3e36b3cfd50732e3085580d840";
    fetchSubmodules = true;
  };

  scrape = path: runCommandLocal "scraped.json" { } ''
    set -o errexit
    set -o nounset
    set -o pipefail

    # Calc CRC for game
    crc="$(${rhash}/bin/rhash --printf "%C" "${path}")"

    # Try to find game in database by CRC
    declare result=""
    declare database=""
    while read -d $'\0' rdb; do
      result="$(${retroarch-tools}/bin/libretrodb_tool "$rdb" find "{'crc':b'$crc'}" || true)"
      if [ -n "$result" ]; then
        database="$(basename "$rdb" | sed 's/\.rdb$//')"
        break
      fi
    done < <(find ${retroarch-database}/share/retroarch/database/rdb/ -name "*.rdb" -print0)

    if [ -z "$result" ]; then
      echo "No matching database entry found for ${path} (crc=$crc)"
      exit 1
    fi

    mkdir "$out"

    # Save game info
    cat > "$out/info.json" << EOF
    {
      "file": "$(${jq}/bin/jq -r '.rom_name' <<< "$result")",
      "name": "$(${jq}/bin/jq -r '.name' <<< "$result")",
      "description": "$(${jq}/bin/jq -r '.description' <<< "$result")"
    }
    EOF

    # Find image for game
    cp "${retroarch-thumbnails}/$database/Named_Boxarts/$(${jq}/bin/jq -r '.name' <<< "$result").png" "$out/image.png"
  '';

  # All found game files: { [system] -> { [name] -> [path] } }
  games = let
    # Scans the `path` for entries of type `filter`
    scan = filter: path: mapAttrs
      (name: _: "${path}/${name}")
      (filterAttrs
        (name: type: type == filter)
        (builtins.readDir path));
  in mapAttrs
    (_: scan "regular")
    (scan "directory" (cleanSource gamesDir));
  
  scraped = concatLists (mapAttrsToList
    (system: games: mapAttrsToList
      (_: path: let
        scraped = scrape path;
      in {
        inherit path system;
        
        inherit (importJSON "${scraped}/info.json") file name description;

        image = builtins.storePath "${scraped}/image.png";
      })
      games)
    games);

in scraped
