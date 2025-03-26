{ config, pkgs, lib, ... }:
{
  # Home Manager configuration for vinko
  home.username = "vinko";
  home.homeDirectory = "/home/vinko";
  home.stateVersion = "23.11";  # Ensure this matches the expected version
  home.keyboard = {
    layout = "us, hr";
    options = "grp:alt_shift_toggle";
  };

  # Install additional packages using `home.packages`
  home.packages = with pkgs; [
    gh
    ripgrep
    inter
  ];

  fonts.fontconfig.enable = true;
  
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

  # Use NVF configuration
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        useSystemClipboard = true;
        viAlias = false;
        vimAlias = true;
        lsp = {
          enable = true;
          null-ls.enable = true;
        };
        ui.borders.plugins.lspsaga.enable = true;
        theme = {
          enable = true;
          name = "catppuccin";
          style = "frappe";
        };

        useSystemClipboard = true;
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        treesitter = {
          enable = true;
          autotagHtml = true;
          highlight = {
            enable = true;
            additionalVimRegexHighlighting = false;
          };
        };

        filetree = {
          nvimTree = {
            enable = true;
            openOnSetup = false;
          };
        };

        visuals = {
          nvim-web-devicons.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit = {
              enable = true;
            };
          };
        };

        languages = {
          enableLSP = true;
          enableTreesitter = true;
          nix = {
            enable = true;
            extraDiagnostics.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format = {
              enable = true;
              type = "alejandra";
            };
          };
          bash = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
          };
          ts = {
            enable = true;
            extensions = {
              ts-error-translator.enable = true;
            };
            extraDiagnostics = {
              enable = true;
              types = [ "eslint_d" ];
            };
            format.enable = true;
            lsp = {
              enable = true;
            };
            treesitter.enable = true;
          };
          css = {
            enable = true;
            lsp.enable = true;
            format.enable = true;
            treesitter.enable = true;
          };
          rust = {
            enable = true;
            crates = {
              enable = true;
            };
            dap.enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          sql.enable = true;
          html.enable = true;
          go.enable = true;
          lua.enable = true;
          python = {
            enable = true;
            format = {
              enable = true;
            };
          };
          markdown.enable = true;
          svelte = {
            enable = true;
            extraDiagnostics.enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          tailwind.enable = true;
        };
      };
    };
  };

  # Example of managing a specific file
  home.file = {
    ".p10k.zsh" = {
      source = ./files/.p10k.zsh;
      executable = true;
    };
  };

  #TO DO: Hyprland config

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
