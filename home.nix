{ config, pkgs, lib, ... }:
{
  # Home Manager configuration for vinko
  home.username = "vinko";
  home.homeDirectory = "/home/vinko";
  home.stateVersion = "23.11";  # Ensure this matches the expected version

  # Install additional packages using `home.packages`
  home.packages = with pkgs; [
    gh
    ripgrep
    inter
    lua-language-server
    rust-analyzer
    nodePackages.typescript-language-server
    nodePackages.svelte-language-server
    nodePackages.vls
    nodePackages.volar
    nodePackages.eslint
    nodePackages.prettier
    eslint_d
    prettierd
    vimPlugins.none-ls-nvim
  ];

  fonts.fontconfig.enable = lib.mkForce true;
  
  # Neovim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraLuaConfig = ''
    	${builtins.readFile ./nvim/init.lua}
    	${builtins.readFile ./nvim/lua/config/lazy.lua}
    '';
  };
  
  # Zsh configuration
  programs.zsh = {
    enable = true;
    initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
  };

  # Example of managing a specific file
  home.file = {
    ".p10k.zsh" = {
      source = ./files/.p10k.zsh;
      executable = true;
    };
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
