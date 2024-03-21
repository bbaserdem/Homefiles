{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # XDG directories
  xdg = {
    cacheHome = "/home/sbp/.cache";
    configHome = "/home/sbp/.config";
    dataHome = "/home/sbp/.local/share";
    stateHome = "/home/sbp/.local/state";
  };

  # Some info regarding usage
  home = {
    username = "sbp";
    homeDirectory = "/home/${config.home.username}";
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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.htop
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

  programs.git = {
    enable = true;
    userName = "Batuhan Başerdem";
    userEmail = "baserdem.batuhan@gmail.com";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
