{ lib, ... }:
let
  entries = builtins.readDir ./.;
  nixFiles = builtins.filter
    (name: lib.hasSuffix ".nix" name && name != "default.nix")
    (builtins.attrNames entries);
  subDirs = builtins.filter
    (name: entries.${name} == "directory" &&
           builtins.pathExists (./. + "/${name}/default.nix"))
    (builtins.attrNames entries);
in {
  imports =
    map (name: ./. + "/${name}") nixFiles ++
    map (name: ./. + "/${name}") subDirs;
}
