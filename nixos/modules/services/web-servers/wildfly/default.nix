{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.wildfly;

  wildflyService = pkgs.stdenv.mkDerivation {
    name = "wildfly-server";
    builder = ./builder.sh;
    inherit (pkgs) wildfly su;
    inherit (cfg)
      enable
      cleanBoot
      serverDir
      user
      group
      userAdmin
      passwordAdmin
      initialHeapMem
      maxHeapMem
      initialMetaspaceSize
      maxMetaspaceSize
      wildflyConfig
      wildflyMode
      wildflyBind
      wildflyBindManagement
      ;
  };

  cleanupScript = pkgs.writeScript "wildfly-cleanup" ''
    #!${pkgs.bash}/bin/bash
    if [ "${toString cfg.cleanBoot}" == "1" ]; then
      rm -rf ${cfg.serverDir}
    fi
  '';

in

{

  ###### interface

  options = {

    services.wildfly = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Wildfly.";
      };

      cleanBoot = mkOption {
        type = types.bool;
        default = false;
        description = "Delete and install the server instance file location every time. No persistence.";
      };

      serverDir = mkOption {
        description = "Location of the server instance files";
        default = "/opt/wildfly";
        type = types.str;
      };

      user = mkOption {
        default = "nobody";
        description = "User account under which Wildfly runs.";
        type = types.str;
      };

      group = mkOption {
        default = "nogroup";
        description = "Group account under which Wildfly runs.";
        type = types.str;
      };

      userAdmin = mkOption {
        default = "admin";
        description = "Admin user who does the web management of Wildfly.";
        type = types.str;
      };

      passwordAdmin = mkOption {
        default = "wildfly";
        description = "Password admin user who does the web management of Wildfly.";
        type = types.str;
      };

      initialHeapMem = mkOption {
        description = "Initial Heap memory.";
        default = "400M";
        type = types.str;
      };

      maxHeapMem = mkOption {
        description = "Max Heap memory.";
        default = "600M";
        type = types.str;
      };

      initialMetaspaceSize = mkOption {
        description = "Initial Metaspace size.";
        default = "100M";
        type = types.str;
      };

      maxMetaspaceSize = mkOption {
        description = "Max Metaspace size.";
        default = "300M";
        type = types.str;
      };

      wildflyConfig = mkOption {
        description = "Wildfly default config.";
        default = "standalone-full.xml";
        type = types.str;
      };

      wildflyMode = mkOption {
        description = "Wildfly default mode.";
        default = "standalone";
        type = types.str;
      };

      wildflyBind = mkOption {
        description = "Wildfly bind address.";
        default = "0.0.0.0";
        type = types.str;
      };

      wildflyBindManagement = mkOption {
        description = "Wildfly bind management address.";
        default = "127.0.0.1";
        type = types.str;
      };

    };

  };

  ###### implementation

  config = mkMerge [
    (mkIf cfg.enable {
      systemd.services.wildfly = {
        description = "WildFly Application Server";
        script = "${wildflyService}/bin/control";
        wantedBy = [ "multi-user.target" ];
      };
    })

    (mkIf ((!cfg.enable) && cfg.cleanBoot) {
      system.activationScripts.wildflyCleanup = {
        text = ''
          ${cleanupScript}
        '';
        deps = [ ];
      };
    })
  ];

}
