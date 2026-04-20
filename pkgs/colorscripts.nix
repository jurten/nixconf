{ stdenv, fetchFromGitHub, bash }:

stdenv.mkDerivation {
  pname = "colorscripts";
  version = "unstable-2024";

  src = fetchFromGitHub {
    owner = "theamallalgi";
    repo  = "colorscripts";
    rev   = "7a8779775f922655564db9e518c6c7b5c4956a9a";
    hash  = "sha256-rUpoRZpJtCjt5U/6gO7tJ7hLbigWi0WEiGMdYyyWJN4=";
  };

  buildInputs = [ bash ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/colorscripts
    cp colorscripts/* $out/share/colorscripts/
    chmod +x $out/share/colorscripts/*

    substitute colorscript $out/bin/colorscript \
      --replace-fail '/usr/share/colorscripts/colorscripts' "$out/share/colorscripts" \
      --replace-fail 'DIR_BLACKLIST="''${DIR_COLORSCRIPTS}/blacklisted"' \
                     'DIR_BLACKLIST="''${XDG_DATA_HOME:-$HOME/.local/share}/colorscripts/blacklisted"'
    chmod +x $out/bin/colorscript
  '';

  meta.description = "ANSI art colorscripts for the terminal (includes Star Wars art)";
}
