{ pkgs, ecsls, system, ... }:
{
  home.file.nvim_conf = {
    source = ./lua;
    target = ".config/nvim/lua";
    recursive = true;
  };

  programs.neovim = {
    enable = true;

    extraConfig = (builtins.readFile ./.vimrc);

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraPackages = with pkgs; [
      nil # Nix
      lua-language-server
      nodePackages.pyright
      clang-tools
      llvmPackages_latest.clang
      nodejs # Copilot
      xclip # Clipboard fix
      ecsls.packages.${system}.default
    ];

  };
}

