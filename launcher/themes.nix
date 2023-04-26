{ lib
, config
, linkFarm
, fetchFromGitHub
, ... }:

linkFarm "emulationstation-themes" {
  "carbon" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-carbon";
    rev = "master";
    hash = "sha256-8RK7QiWixfFo+EcO8VuOOvZBi7ybGDPqsHeNUVidWC4=";
  };
  "carbon-2021" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-carbon-2021";
    rev = "master";
    hash = "sha256-EmiDgxQfSDpn7M7OwiT0s1DnXLx5rAxpLzGbPrqzBfc=";
  };
  "pixel" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-pixel";
    rev = "master";
    hash = "sha256-tvcsppdnZY9GrYTPJqnNaskuj5o4eEq8Qk8SvBdDO5o=";
  };
  "carbon-nometa" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-carbon-nometa";
    rev = "master";
    hash = "sha256-qdEMNYqLPJB25lidn3XTVZjXKT7Zs0Q82MGd83QDeI4=";
  };
  "simple-dark" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-simple-dark";
    rev = "master";
    hash = "sha256-QNHr8LFw1b35pxdhqCJ3bhXNjKWfzBu8EwjW682+hic=";
  };
  "zoid" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-zoid";
    rev = "master";
    hash = "sha256-5VdFqQ0Kmg0ux+PzX9uPfTvPxkEcRG6mZzu2Ooi5XsU=";
  };
  "clean-look" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-clean-look";
    rev = "master";
    hash = "sha256-kInUtQ4koY793bYkLxhrf5S4XJ8n0VtFZayerebzsFo=";
  };
  "nbba" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-nbba";
    rev = "master";
    hash = "sha256-PSQ3TI22Ch6hshcbHRBSgNlspv5GBQ/wm5UJBBqenoQ=";
  };
  "simplified-static-canela" = fetchFromGitHub {
    owner = "RetroPie";
    repo = "es-theme-simplified-static-canela";
    rev = "master";
    hash = "sha256-BGka4fRWsPkKPXE51OnzSxXj5Wok1Bi781gDXNfV5Lk=";
  };
}
