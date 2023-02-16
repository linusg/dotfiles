{
  config,
  pkgs,
  wallpaper,
  ...
}: let
  colors = {
    accent = "0073d5";
    background = "111111";
  };
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "linus";
  home.homeDirectory = "/home/linus";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.file.".config/wallpaper.jpg".source = wallpaper;

  home.packages = with pkgs; [
    alejandra
    discord
    element-desktop
    epiphany
    gimp
    glib # For gsettings
    gnome.adwaita-icon-theme
    gnome.nautilus
    lftp
    mullvad-vpn
    neofetch
    networkmanagerapplet
    nodejs
    optipng
    pavucontrol
    poetry
    pre-commit
    prismlauncher
    pulseaudio # For pactl
    python
    python310Packages.black
    python310Packages.pip
    swaybg
    swaylock-effects
    thefuck
    ungoogled-chromium
    vlc
    yarn
  ];

  home.pointerCursor = {
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font.name = "Inter 10";
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = "(200, 400)";
        height = 100;
        offset = "0x5";
        origin = "top-center";
        background = "#${colors.background}";
        frame_color = "#${colors.accent}";
        frame_width = 2;
        corner_radius = 5;
        gap_size = 5;
        font = "JetBrains Mono 10";
        format = "<span color='#${colors.accent}'>[</span><span alpha='70%'>%a</span> %s<span color='#${colors.accent}'>]</span>\\n%b";
        markup = "full";
      };
    };
  };
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        timeout = 15;
        command = "${pkgs.procps}/bin/pgrep swaylock && ${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.exa = {
    enable = true;
    enableAliases = true;
  };
  programs.firefox.enable = true;
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Linus Groh";
    userEmail = "mail@linusgroh.de";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 10;
    };
    settings = {
      scrollback_lines = -1;
      window_padding_width = "0 4";
      background_opacity = "0.8";
      remember_window_size = false;
    };
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override {
      plugins = with pkgs; [
        rofi-emoji
      ];
    };
    font = "JetBrains Mono 10";
    theme = "Arc-Dark";
    terminal = "kitty";
    extraConfig = {
      modi = "drun,run,emoji";
    };
  };
  programs.swaylock.settings = {
    effect-blur = "50x4";
    image = "/home/linus/.config/wallpaper.jpg";
    font = "JetBrains Mono";
    clock = true;
    timestr = "%R";
    datestr = "%A";
    ignore-empty-password = true;
    indicator-idle-visible = true;
    indicator-radius = 120;
    bs-hl-color = "${colors.accent}";
    key-hl-color = "${colors.accent}";
    inside-color = "${colors.background}aa";
    inside-ver-color = "${colors.background}aa";
    inside-clear-color = "${colors.background}aa";
    inside-wrong-color = "${colors.background}aa";
    line-color = "00000000";
    line-clear-color = "00000000";
    line-caps-lock-color = "00000000";
    line-ver-color = "00000000";
    line-wrong-color = "00000000";
    ring-color = "${colors.background}";
    ring-ver-color = "${colors.background}";
    ring-clear-color = "${colors.background}";
    ring-wrong-color = "${colors.background}";
    text-color = "ffffff";
    text-ver-color = "ffffff";
    text-clear-color = "ffffff";
    text-wrong-color = "ffffff";
    text-caps-lock-color = "ffffff";
    separator-color = "00000000";
  };
  programs.thunderbird = {
    enable = true;
    profiles = {
      leute-server = {
        isDefault = true;
      };
    };
  };
  programs.vim.enable = true;
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      ms-python.vscode-pylance
      pkief.material-icon-theme
      zhuangtongfa.material-theme
    ];
    userSettings = {
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
      "files.autoSave" = "afterDelay";
      "python.formatting.provider" = "black";
      "python.languageServer" = "Pylance";
      "terminal.integrated.enableMultiLinePasteWarning" = false;
      "workbench.colorTheme" = "One Dark Pro";
      "workbench.iconTheme" = "material-icon-theme";
      "[css]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[vue]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
    };
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [
          "tray"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "idle_inhibitor"
          "network"
          "backlight"
          "pulseaudio"
          "battery"
          "clock"
        ];
        "hyprland/window" = {
          max-length = 50;
        };
        idle_inhibitor = {
          format-icons = {
            activated = "☕";
            deactivated = "😴";
          };
          format = "<span color='#${colors.accent}'>[</span>{icon}<span color='#${colors.accent}'>]</span>";
        };
        backlight = {
          format = "<span color='#${colors.accent}'>[</span><span alpha='70%'>blg</span> {percent}%<span color='#${colors.accent}'>]</span>";
        };
        battery = {
          format = "<span color='#${colors.accent}'>[</span><span alpha='70%'>bat</span> {capacity}%<span color='#${colors.accent}'>]</span>";
          format-charging = "<span color='#${colors.accent}'>[</span><span alpha='70%'>bat</span> {capacity}%⚡<span color='#${colors.accent}'>]</span>";
          format-discharging-warning = "<span color='#${colors.accent}'>[</span><span alpha='70%'>bat</span> {capacity}%⚠️<span color='#${colors.accent}'>]</span>";
          states = {
            warning = 15;
          };
        };
        clock = {
          format = "<span color='#${colors.accent}'>[</span>{:%H:%M}<span color='#${colors.accent}'>]</span>";
          tooltip = true;
          tooltip-format = "{:%Y-%m-%d}";
        };
        network = {
          format-ethernet = "<span color='#${colors.accent}'>[</span><span alpha='70%'>net</span> <span color='#${colors.accent}'>]</span>";
          format-wifi = "<span color='#${colors.accent}'>[</span><span alpha='70%'>net</span> <span color='#${colors.accent}'>]</span>";
          format-disconnected = "<span color='#${colors.accent}'>[</span><span alpha='70%'>net</span> <span color='#${colors.accent}'>]</span>";
          max-length = 12;
          tooltip-format = "{essid}\n{ifname}\n{ipaddr}";
        };
        pulseaudio = {
          format = "<span color='#${colors.accent}'>[</span><span alpha='70%'>vol</span> {volume}%<span color='#${colors.accent}'>]</span>";
          format-muted = "<span color='#${colors.accent}'>[</span><span alpha='70%'>vol</span> Muted<span color='#${colors.accent}'>]</span>";
          on-click = "pavucontrol";
        };
        tray = {
          show-passive-items = true;
          spacing = 2;
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrains Mono", "Material Icons";
        font-size: 12px;
      }
      window#waybar {
        background: #111;
        color: #eee;
      }
      #backlight,
      #battery,
      #clock,
      #idle_inhibitor,
      #network,
      #pulseaudio,
      #window {
        margin: 2px 0 2px 2px;
      }
      #window {
        margin-left: 0;
      }
      #clock {
        margin-right: 10px;
      }
    '';
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    initExtra = ''
      eval $(thefuck --alias)
      export PATH="$(yarn global bin):$PATH"
    '';
    shellAliases = {
      cat = "bat";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git"];
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
  };

  xdg.configFile."hypr/hyprland.conf".text = ''
    general {
      gaps_in = 5
      gaps_out = 10
      border_size = 2
      col.inactive_border = 0x00000000
      col.active_border = 0xff${colors.accent}
      layout = dwindle
    }
    decoration {
      rounding = 6
      blur = true
      blur_size = 5
      blur_passes = 4
      blur_new_optimizations = true
      drop_shadow = false
    }
    input {
      kb_layout = gb
      repeat_rate = 25
      repeat_delay = 300
      touchpad {
        natural_scroll = true
      }
    }
    gestures {
      workspace_swipe = true
    }
    misc {
      disable_hyprland_logo = true
      focus_on_activate = true
    }
    dwindle {
      pseudotile = true
      preserve_split = true
    }

    windowrulev2 = float, class:^(pavucontrol|udiskie|float)$

    $mainMod = SUPER
    bind = $mainMod, E, exec, rofi -show emoji
    bind = $mainMod, F, exec, nautilus
    bind = $mainMod, J, togglesplit
    bind = $mainMod, L, exec, swaylock
    bind = $mainMod, M, exit
    bind = $mainMod, Q, killactive
    bind = $mainMod, Return, exec, kitty -1
    bind = $mainMod, Space, exec, rofi -show drun
    bind = CTRL ALT, T, exec, kitty -1 --class=float
    bind = ALT, Tab, workspace, e+1
    bind = ALT SHIFT, Tab, workspace, e-1
    binde = ,XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0
    binde = ,XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
    binde = ,XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0
    binde = ,XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
    binde = ,XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
    binde = ,XF86MonBrightnessDown, exec, light -U 10
    binde = ,XF86MonBrightnessUp, exec, light -A 10
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod SHIFT, mouse:272, resizewindow

    # Desktop
    exec-once = waybar
    exec-once = swaybg -m fill -i ~/.config/wallpaper.jpg
    exec-once = hyprctl setcursor capitaine-cursors 24
    exec-once = gsettings set org.gnome.desktop.interface cursor-theme capitaine-cursors
    exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2

    # graphical-session.target starts further services (nm-applet, swayidle, udiskie)
    exec-once = systemctl --user start graphical-session.target

    # Autostart
    windowrule = workspace 1 silent, firefox
    windowrule = workspace 2 silent, discord
    exec-once = mullvad-gui
    exec-once = firefox
    exec-once = discord
    exec-once = sleep 10 && hyprctl keyword windowrule "workspace unset, firefox"
    exec-once = sleep 10 && hyprctl keyword windowrule "workspace unset, discord"
  '';
}