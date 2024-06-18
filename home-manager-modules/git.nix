{ config, pkgs, user-info, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    userName = user-info.git.name;
    userEmail = user-info.git.email;
  };
}