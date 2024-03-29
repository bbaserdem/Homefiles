{ config, pkgs, ... }:

{
  home.username = "sbp";
  home.homeDirectory = "/home/sbp";

  targets.genericLinux.enable = true; # ENABLE THIS ON NON NIXOS

  home = {
    keyboard = {
      layout = "us,tr,us";
      variant = "dvorak-alt-intl,f,altgr-intl";
      options = [
        "grp:alt_caps_toggle"
      ];
    };
    language = {
      base = "en_US.UTF-8";
      collate = "tr_TR.UTF-8";
      name = "tr_TR.UTF-8";
    };
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      SUDO_EDITOR = "nvim";
    };
    shellAliases = {
      py = "bpython";
      mutt = "neomutt";
      arch-killorphans = "sudo pacman -Rns $(pacman -Qttdq)";
    };
  };

  xdg = {
    cacheHome = "/home/sbp/.cache";
    configHome = "/home/sbp/.config";
    dataHome = "/home/sbp/.local/share";
    stateHome = "/home/sbp/.local/state";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    iconTheme = {
      name = "GruvboxPlus";
      package = pkgs.gruvbox-plus;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = "1";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = "1";
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.htop
    pkgs.git
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.beets = {
    enable = true;
    mpdIntegration = {
      enableStats = true;
      enableUpdate = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "bbaserdem";
    userEmail = "baserdem.batuhan@gmail.com";
    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      pull = {
        rebase = false;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    extraConfig = "allow-loopback-pinentry";
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
