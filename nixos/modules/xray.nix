{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.age.keyFile = "/home/slava/.config/sops/age/keys.txt";
  sops.secrets.xray_config = {
    sopsFile = ../../secrets/xray-client.json;
    format = "json";
    key = "";
    restartUnits = ["xray.service"];
  };

  services.xray = {
    enable = true;
    settingsFile = config.sops.secrets.xray_config.path;
  };
}
