
{ config, pkgs, ...}:
{
  # ------------------------------------------------------
  # import base64
  # # The 'sha256-' in the beginning should be removed
  # text = b"YDw3tbOSg3k/Sff/GPheb0rK84cPq3Bs3eIJDEBj2j0="
  # print(base64.decodebytes(text).hex())
  # ------------------------------------------------------
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [
      clang-tools
      gdb
    ]);
    userSettings = builtins.fromJSON (builtins.readFile ./dotfiles/settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ./dotfiles/keybindings.json);
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      vscodevim.vim
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
      twxs.cmake
      ms-vscode.cpptools
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "kanagawa-vscode-color-theme";
        publisher = "metaphore";
        version = "0.4.0";
        sha256 = "076e6c68c91a4f1ef7ba770fb404052907c7d63e5531b0faee58093c9726def9";
      }
      {
        name = "shader";
        publisher = "slevesque";
        version = "1.1.5";
        sha256 = "3dfdfb15e40c365bfbe1fecb333f7e08ab1c17a5234d9ed9a5c69914ab57d993";
      }
      {
        name = "kanagawa-black";
        publisher = "lamarcke";
        version = "1.0.5";
        sha256 = "603c37b5b39283793f49f7ff18f85e6f4acaf3870fab706cdde2090c4063da3d";
      }
    ];
  };
}