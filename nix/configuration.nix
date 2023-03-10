{
  config,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "linus-framework";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "ter-v32n";
    keyMap = "uk";
    packages = with pkgs; [
      terminus_font
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport32Bit = true;

  services.blueman.enable = true;
  services.dbus.enable = true;
  services.fprintd.enable = true;
  services.gvfs.enable = true;
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
  services.mullvad-vpn.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.printing.enable = true;
  services.thermald.enable = true;
  services.udisks2.enable = true;
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 2;
    criticalPowerAction = "PowerOff";
  };
  services.xserver = {
    enable = true;
    layout = "gb";
    displayManager.sddm.enable = true;
    libinput.enable = true;
  };

  environment.pathsToLink = ["/share/zsh"];
  environment.sessionVariables = {
    GDK_SCALE = "2";
    # NOTE: QT_SCALE_FACTOR=2 isn't needed when using QT_QPA_PLATFORM=wayland, which already scales appropriately.
    QT_QPA_PLATFORMTHEME = "gtk3";
    XCURSOR_THEME = "capitaine-cursors";
    XCURSOR_SIZE = "48";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security.pam.services.swaylock = {};
  security.rtkit.enable = true;

  programs.light.enable = true;
  programs.nm-applet.enable = true;
  programs.steam.enable = true;

  users.users.linus = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "podman"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  fonts.fonts = with pkgs; [
    inter
    jetbrains-mono
  ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It???s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
