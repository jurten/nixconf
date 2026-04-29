{pkgs, inputs, ...}:
let
  addons = inputs.nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons;
in {
  programs.firefox = {
    enable = true;
    profiles.default.extensions = with addons; [
      ublock-origin
      vimium
      darkreader
      sponsorblock
      tree-style-tab
      web-clipper-obsidian
    ];
  };
}
