{ config, pkgs, user-info, ... }:
{
  home.packages = with pkgs.gnomeExtensions; [
    dash-to-dock
  ];
  # command to check use values: dconf dump /
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          dash-to-dock.extensionUuid
        ];
        favorite-apps = [
          "org.gnome.Console.desktop"
          "code.desktop"
          "google-chrome.desktop"
          "org.telegram.desktop.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };
      "org/gnome/mutter".edge-tiling = true;
      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file://${./wallpapers/pr6tlrhvsefd1.jpeg}";
        picture-uri-dark = "file://${./wallpapers/pr6tlrhvsefd1.jpeg}";
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        always-center-icons = false;
        animation-time = 0.2;
        autohide = false;
        autohide-in-fullscreen = false;
        background-color = "rgb(0,0,0)";
        background-opacity = 0.9;
        custom-background-color = true;
        custom-theme-customize-running-dots = true;
        custom-theme-running-dots-color = "rgb(230,97,0)";
        custom-theme-shrink = false;
        dash-max-icon-size = 48;
        dock-fixed = true;
        dock-position = "LEFT";
        extend-height = true;
        height-fraction = 0.9;
        hide-delay = 0.2;
        intellihide = true;
        intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
        pressure-threshold = 100.0;
        preview-size-scale = 0.0;
        require-pressure-to-show = true;
        running-indicator-style = "DOTS";
        show-delay = 0.25;
        show-dock-urgent-notify = true;
        show-favorites = true;
        show-trash = true;
        transparency-mode = "FIXED";
      };
    };
  };
}