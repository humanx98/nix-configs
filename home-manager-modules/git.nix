{
  config,
  pkgs,
  user-info,
  ...
}:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    settings.user = {
      name = user-info.git.name;
      email = user-info.git.email;
    };
  };
}
