{ config, pkgs, ... }:
{
  # ------------------------------------------------------
  # import base64
  # # sha256-LNtXYZ65Lka1lpxeKozK6LB0yaxAjHsfVsCJ8ILX8io=
  # # The 'sha256-' in the beginning should be removed
  # text = b"LNtXYZ65Lka1lpxeKozK6LB0yaxAjHsfVsCJ8ILX8io="
  # print(base64.decodebytes(text).hex())
  # ------------------------------------------------------
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (
      ps: with ps; [
        clang-tools
        gdb
      ]
    );
    userSettings = builtins.fromJSON (builtins.readFile ./dotfiles/settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ./dotfiles/keybindings.json);
    mutableExtensionsDir = false;
    extensions =
      with pkgs.vscode-extensions;
      [
        ms-python.python
        vscodevim.vim
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        ms-vscode.cpptools
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "cmake-language-support-vscode";
          publisher = "josetr";
          version = "0.0.9";
          sha256 = "2cdb57619eb92e46b5969c5e2a8ccae8b074c9ac408c7b1f56c089f082d7f22a";
          
        }
        {
          name = "shader";
          publisher = "slevesque";
          version = "1.1.5";
          sha256 = "3dfdfb15e40c365bfbe1fecb333f7e08ab1c17a5234d9ed9a5c69914ab57d993";
        }
      ];
  };
}
