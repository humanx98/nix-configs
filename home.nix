{ config, pkgs, inputs, user-info, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user-info.name;
  home.homeDirectory = "/home/${user-info.name}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
	
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs = {
    overlays = [
      (final: prev: {
        vimPlugins = prev.vimPlugins // {
          own-plugin-mellifluous-nvim = prev.vimUtils.buildVimPlugin {
            name = "plugin-mellifluous";
            src = inputs.plugin-mellifluous;
          };
        };
      })
    ];
  };

  imports = [
    ./home-manager-modules/nvim
    ./home-manager-modules/vscode
    ./home-manager-modules/gnome.nix
    ./home-manager-modules/git.nix
  ];

  home.packages = with pkgs; [
    neofetch
    tree
    google-chrome
    telegram-desktop
    zed-editor
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
