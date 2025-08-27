{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];
  sops = {
    # Point to the age key cloned manually by the user.
    age.keyFile = config.home.homeDirectory + "/nix-secret/keys.txt.age";

    defaultSopsFile = ../secrets/secrets.yaml;
    validateSopsFiles = false;

    secrets = {
      "useremail" = {};
      "google_cloud_project" = {};
    };
  };
}
