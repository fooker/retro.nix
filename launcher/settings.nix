{ lib
, config
, writeText
, ...}:

with lib;

writeText "emulationstation-settings.cfg" (concatStringsSep "\n"
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
    "AudioDevice" = "";
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
    "ThemeSet" = "pixel";
    "TransitionStyle" = "instant";
    "UIMode" = "Full";
    "UIMode_passkey" = "";
    "VlcScreenSaverResolution" = "original";
  }))
