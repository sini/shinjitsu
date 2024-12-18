{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.system.battery;
in
{
  options.system.battery = with types; {
    enable = mkBoolOpt false "Whether or not to enable battery optimizations and utils.";
  };

  config = mkIf cfg.enable {
    services = {
      # Better scheduling for CPU cycles - thanks System76!!!
      system76-scheduler.settings.cfsProfiles.enable = true;
      # Enable TLP (better than gnomes internal power manager)
      tlp = {
        enable = true;
        settings = {
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        };
      };

      # Disable GNOMEs power management
      power-profiles-daemon.enable = false;

      # Enable thermald (only necessary if on Intel CPUs)
      thermald.enable = true;
    };

    # Enable powertop
    powerManagement.powertop.enable = true;
  };
}
