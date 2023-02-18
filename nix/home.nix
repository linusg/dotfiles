{
  config,
  pkgs,
  wallpaper,
  ...
}: let
  colors = {
    accent = "0073d5";
    background = "111111";
    error = "d50043";
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
    alsa-utils # For alsamixer
    baobab
    clang-tools # For clang-format
    discord
    element-desktop
    epiphany
    gimp
    glib # For gsettings
    gnome.adwaita-icon-theme
    gnome.eog
    gnome.nautilus
    grim
    jetbrains.clion
    lftp
    lshw
    mullvad-vpn
    neofetch
    networkmanagerapplet
    nodejs
    optipng
    pavucontrol
    pciutils # For lspci
    poetry
    pre-commit
    prismlauncher
    python3
    python310Packages.black
    python310Packages.pip
    scc
    slurp
    swaybg
    swaylock-effects
    thefuck
    ungoogled-chromium
    usbutils # For lsusb
    vlc
    wl-clipboard
    xdg-user-dirs
    yarn
  ];

  home.pointerCursor = {
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font.name = "Inter 10";
    iconTheme = {
      name = "la-capitaine-icon-theme";
      package = pkgs.la-capitaine-icon-theme;
    };
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = config.gtk.iconTheme.name;
      package = config.gtk.iconTheme.package;
      size = "32x32";
    };
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
      urgency_critical = {
        frame_color = "#${colors.error}";
        format = "<span color='#${colors.error}'>[</span><span alpha='70%'>%a</span> %s<span color='#${colors.error}'>]</span>\\n%b";
      };
    };
  };
  services.gammastep = {
    enable = true;
    tray = true;
    # London
    latitude = 51.5;
    longitude = 0.0;
  };
  services.poweralertd.enable = true;
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
    image = "${config.home.homeDirectory}/.config/wallpaper.jpg";
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
    profiles = {};
  };
  programs.vim.enable = true;
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dbaeumer.vscode-eslint
      eamodio.gitlens
      esbenp.prettier-vscode
      ms-python.python
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
      # Required for the Python language server, which tries to add this to the config file (but set to true)
      "[python]" = {
        "editor.formatOnType" = false;
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
          "cpu"
          "memory"
          "temperature"
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
        cpu = {
          interval = 1;
          format = "<span color='#${colors.accent}'>[</span><span color='limegreen'>{icon0} {icon1} {icon2} {icon3} {icon4} {icon5} {icon6} {icon7}</span> {usage}%<span color='#${colors.accent}'>]</span>";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          on-click = "kitty --class=float btm --default_widget_type=cpu --expanded";
        };
        backlight = {
          format = "<span color='#${colors.accent}'>[</span>{icon} {percent}%<span color='#${colors.accent}'>]</span>";
          format-icons = ["🔅" "🔆"];
        };
        battery = {
          format = "<span color='#${colors.accent}'>[</span>🔋 {capacity}%<span color='#${colors.accent}'>]</span>";
          format-charging = "<span color='#${colors.accent}'>[</span>⚡ {capacity}%<span color='#${colors.accent}'>]</span>";
          format-discharging-warning = "<span color='#${colors.accent}'>[</span>🪫 {capacity}%<span color='#${colors.accent}'>]</span>";
          states = {
            warning = 15;
          };
          on-click = "kitty --class=float btm --battery --default_widget_type=battery --expanded";
        };
        clock = {
          format = "<span color='#${colors.accent}'>[</span>{:%H:%M}<span color='#${colors.accent}'>]</span>";
          format-alt = "<span color='#${colors.accent}'>[</span>{:%Y-%m-%d}<span color='#${colors.accent}'>]</span>";
        };
        idle_inhibitor = {
          format = "<span color='#${colors.accent}'>[</span>{icon}<span color='#${colors.accent}'>]</span>";
          format-icons = {
            activated = "☕";
            deactivated = "😴";
          };
        };
        memory = {
          interval = 1;
          format = "<span color='#${colors.accent}'>[</span>{used:0.1f}/{total:0.1f}GiB<span color='#${colors.accent}'>]</span>";
          on-click = "kitty --class=float btm --default_widget_type=memory --expanded";
        };
        network = {
          format = "<span color='#${colors.accent}'>[</span>🌐<span color='#${colors.accent}'>]</span>";
          format-disconnected = "<span color='#${colors.accent}'>[</span>❌<span color='#${colors.accent}'>]</span>";
          max-length = 12;
          tooltip-format = "{essid} ({signalStrength}%, {frequency}GHz)\n{ifname}\n{ipaddr}";
          on-click = "kitty --class=float btm --default_widget_type=network --expanded";
        };
        pulseaudio = {
          format = "<span color='#${colors.accent}'>[</span>{icon} {volume}%<span color='#${colors.accent}'>]</span>";
          format-muted = "<span color='#${colors.accent}'>[</span>🔇 Muted<span color='#${colors.accent}'>]</span>";
          format-icons = ["🔈" "🔉" "🔊"];
          on-click = "pavucontrol";
        };
        temperature = {
          interval = 5;
          hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input"; # coretemp
          format = "<span color='#${colors.accent}'>[</span>🌡️ {temperatureC}°C<span color='#${colors.accent}'>]</span>";
          on-click = "kitty --class=float btm --default_widget_type=temperature --expanded";
        };
        tray = {
          show-passive-items = true;
          spacing = 2;
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrains Mono";
        font-size: 12px;
      }
      window#waybar {
        background: #111;
        color: #eee;
      }
      #backlight,
      #battery,
      #clock,
      #cpu,
      #idle_inhibitor,
      #memory,
      #network,
      #pulseaudio,
      #temperature,
      #window {
        margin: 2px 0 2px 2px;
      }
      #window {
        margin-left: 0;
      }
      #clock {
        margin-right: 10px;
      }
      #tray {
        margin-left: 10px;
      }
    '';
  };
  programs.zsh = let
    serenitySourceDir = "${config.home.homeDirectory}/Dev/serenity";
  in {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    initExtra = ''
      eval $(thefuck --alias)
      export PATH="$(yarn global bin):$PATH"
      export EDITOR='vim';
      export SERENITY_SOURCE_DIR="${serenitySourceDir}"
    '';
    shellAliases = {
      cat = "bat";
      serenity = "${serenitySourceDir}/Meta/serenity.sh";
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
    windowrulev2 = float, title:^(Firefox — Sharing Indicator|Picture-in-Picture|Open File|Open Folder)$
    windowrulev2 = pin, title:^(Picture-in-Picture)$
    windowrulev2 = size 300 180, title:^(Picture-in-Picture)$
    windowrulev2 = move 800 540, title:^(Picture-in-Picture)$

    $mainMod = SUPER
    bind = $mainMod, E, exec, rofi -show emoji
    bind = $mainMod, F, exec, nautilus
    bind = $mainMod, J, togglesplit
    bind = $mainMod, L, exec, swaylock
    bind = $mainMod, M, exit
    bind = $mainMod, Q, killactive
    bind = $mainMod, Return, exec, kitty -1
    bind = $mainMod, Space, exec, rofi -show drun -show-icons
    bind = , Print, exec, screenshot_path="$(xdg-user-dir PICTURES)/$(date +'screenshot_%F_%H%M%S.png')"; grim -g "$(slurp)" "$screenshot_path" && wl-copy < "$screenshot_path" && dunstify --raw_icon "$screenshot_path" "Screenshot" "$screenshot_path has been saved and copied to the clipboard."
    bind = $mainMod, Print, exec, screenshot_path="$(xdg-user-dir PICTURES)/$(date +'screenshot_%F_%H%M%S.png')"; grim "$screenshot_path" && wl-copy < "$screenshot_path" && dunstify --raw_icon "$screenshot_path" "Screenshot" "$screenshot_path has been saved and copied to the clipboard."
    bind = CTRL ALT, T, exec, kitty -1 --class=float
    bind = ALT, Tab, workspace, e+1
    bind = ALT SHIFT, Tab, workspace, e-1
    binde = ,XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    binde = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0
    binde = ,XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    binde = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1.0
    binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    binde = ,XF86MonBrightnessDown, exec, light -U 10
    binde = ,XF86MonBrightnessUp, exec, light -A 10
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod SHIFT, mouse:272, resizewindow

    # Hacks :^)
    # https://wiki.hyprland.org/FAQ/#some-of-my-apps-take-a-really-long-time-to-open
    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = systemctl --user restart 'xdg-desktop-portal*'
    # https://wiki.hyprland.org/Nix/Options-Overrides/#xwayland-hidpi
    exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2

    # Desktop
    exec-once = waybar
    exec-once = swaybg -m fill -i ~/.config/wallpaper.jpg
    exec-once = hyprctl setcursor capitaine-cursors 24
    exec-once = gsettings set org.gnome.desktop.interface cursor-theme capitaine-cursors

    # graphical-session.target starts further services (nm-applet, swayidle, udiskie)
    exec-once = systemctl --user start graphical-session.target

    # Autostart
    windowrule = workspace 1 silent, firefox
    windowrule = workspace 2 silent, thunderbird
    windowrule = workspace 3 silent, discord
    exec-once = mullvad-gui
    exec-once = firefox
    exec-once = thunderbird
    exec-once = discord
    exec-once = sleep 60 && hyprctl keyword windowrule "workspace unset, firefox"
    exec-once = sleep 60 && hyprctl keyword windowrule "workspace unset, thunderbird"
    exec-once = sleep 60 && hyprctl keyword windowrule "workspace unset, discord"
  '';
}
