{ lib, pkgs, ... }: config:

with lib;

let
  # The systems ROM path leverages expansion to ensure the actual ROMs are located inside the path
  systems = pkgs.writeText "emulationstation-systems.cfg" ''
    <systemList>
    ${concatMapStringsSep "\n" (system: with system; ''
      <system>
        <name>${id}</name>
        <fullname>${fullName}</fullname>
        <path>~/roms/${id}</path>
        <extension>${concatMapStringsSep " " (ext: ".${ext}") fileExtensions}</extension>
        <command>${emulators.${defaultEmulator}.command}</command>
        <platform>${id}</platform>
        <theme>${id}</theme>
      </system>
    '') (filter (system: system.enable) (attrValues config.systems))}
    </systemList>
  '';

  gamelists = pkgs.linkFarm "emulationstation-gamelists" (mapAttrs'
    (system: games: nameValuePair "${system}/gamelist.xml" (pkgs.writeText "emulationstation-gamelists-${system}" ''
      <gameList>
      ${concatMapStringsSep "\n" (game: with game; ''
        <game>
          <path>${game.file}</path>
          <name>${name}</name>
          <desc>${description}</desc>
          ${optionalString (image != null) ''<image>${image}</image>''}
          ${optionalString (thumbnail != null) ''<thumbnail>${thumbnail}</thumbnail>''}
        </game>
      '') games}
      </gameList>
    ''))
    (groupBy
      (game: game.system)
      (config.games)));
  
  inputs = pkgs.writeText "emulationstation-input.cfg" ''
    <inputList>
      <inputConfig type="keyboard" deviceName="Keyboard" deviceGUID="-1">
        <input name="a" type="key" id="108" value="1" />
        <input name="b" type="key" id="107" value="1" />
        <input name="down" type="key" id="100" value="1" />
        <input name="hotkeyenable" type="key" id="121" value="1" />
        <input name="left" type="key" id="115" value="1" />
        <input name="leftshoulder" type="key" id="111" value="1" />
        <input name="lefttrigger" type="key" id="119" value="1" />
        <input name="right" type="key" id="102" value="1" />
        <input name="rightshoulder" type="key" id="117" value="1" />
        <input name="righttrigger" type="key" id="114" value="1" />
        <input name="select" type="key" id="104" value="1" />
        <input name="start" type="key" id="103" value="1" />
        <input name="up" type="key" id="101" value="1" />
        <input name="x" type="key" id="105" value="1" />
        <input name="y" type="key" id="106" value="1" />
      </inputConfig>
    </inputList>
  '';

  settings = pkgs.writeText "emulationstation-settings.cfg" (concatStringsSep "\n"
    (mapAttrsToList (name: value: {
      "bool" = ''<bool name="${name}" value="${boolToString value}" />'';
      "int" = ''<int name="${name}" value="${toString value}" />'';
      "string" = ''<string name="${name}" value="${toString value}" />'';
    }.${builtins.typeOf value}) {
      "BackgroundIndexing" = false;
      "BackgroundJoystickInput" = false;
      "CollectionShowSystemInfo" = true;
      "DisableKidStartMenu" = true;
      "DoublePressRemovesFromFavs" = false;
      "DrawFramerate" = false;
      "EnableSounds" = true;
      "ForceDisableFilters" = false;
      "IgnoreLeadingArticles" = false;
      "LocalArt" = true;
      "MoveCarousel" = true;
      "ParseGamelistOnly" = true;
      "QuickSystemSelect" = true;
      "ScrapeRatings" = false;
      "ScreenSaverControls" = true;
      "ScreenSaverOmxPlayer" = false;
      "ScreenSaverVideoMute" = false;
      "ShowHelpPrompts" = true;
      "ShowHiddenFiles" = false;
      "SlideshowScreenSaverCustomMediaSource" = false;
      "SlideshowScreenSaverRecurse" = false;
      "SlideshowScreenSaverStretch" = false;
      "SortAllSystems" = false;
      "StretchVideoOnScreenSaver" = false;
      "SystemSleepTimeHintDisplayed" = false;
      "ThreadedLoading" = false;
      "UseCustomCollectionsSystem" = true;
      "UseFullscreenPaging" = false;
      "VideoAudio" = true;
      "VideoOmxPlayer" = false;
      "MaxVRAM" = 100;
      "ScraperResizeHeight" = 0;
      "ScraperResizeWidth" = 400;
      "ScreenSaverSwapMediaTimeout" = 10000;
      "ScreenSaverSwapVideoTimeout" = 30000;
      "ScreenSaverTime" = 300000;
      "SystemSleepTime" = 0;
      "AudioCard" = "default";
      "AudioDevice" = "Master";
      "CollectionSystemsAuto" = "";
      "CollectionSystemsCustom" = "";
      "GamelistViewStyle" = "automatic";
      "LeadingArticles" = "a,an,the";
      "OMXAudioDev" = "both";
      "PowerSaverMode" = "disabled";
      "SaveGamelistsMode" = "never";
      "Scraper" = "TheGamesDB";
      "ScreenSaverBehavior" = "slideshow";
      "ScreenSaverGameInfo" = "never";
      "SlideshowScreenSaverBackgroundAudioFile" = "";
      "SlideshowScreenSaverImageFilter" = ".png,.jpg";
      "SlideshowScreenSaverMediaDir" = "~/.emulationstation/slideshow/media";
      "SlideshowScreenSaverVideoFilter" = ".mp4,.avi";
      "StartupSystem" = "";
      "ThemeSet" = "carbon";
      "TransitionStyle" = "fade";
      "UIMode" = "Full";
      "UIMode_passkey" = "";
      "VlcScreenSaverResolution" = "original";
    }));

  themes = pkgs.linkFarm "emulationstation-themes" {
    "carbon" = pkgs.fetchFromGitHub {
      owner = "RetroPie";
      repo = "es-theme-carbon";
      rev = "master";
      hash = "sha256-8RK7QiWixfFo+EcO8VuOOvZBi7ybGDPqsHeNUVidWC4=";
    };
  };
  
  home = pkgs.linkFarm "retro-config" ([
    { name = ".emulationstation/es_systems.cfg"; path = systems; }
    { name = ".emulationstation/gamelists"; path = gamelists; }
    { name = ".emulationstation/es_input.cfg"; path = inputs; }
    { name = ".emulationstation/es_settings.cfg"; path = settings; }
    { name = ".emulationstation/themes"; path = themes; }
    { name = ".emulationstation/es_log.txt"; path = "/tmp/es_log.txt"; }
  ] ++ (map (game: {
    name = "roms/${game.system}/${game.file}";
    inherit (game) path;
  }) config.games));

  emulationstation = pkgs.callPackage ./pkgs/emulationstation.nix { };

in pkgs.runCommandLocal "launcher" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
} ''
  makeWrapper "${emulationstation}/bin/emulationstation" "$out/bin/retro" \
    --set HOME "${home}"
  
  ln -s "${home}" "$out/home"
''
