{ pkgs, ... }: {
  home.packages = with pkgs; [
    databricks-cli
    whisper-cpp
    zip
    unzip
  ];
}
