{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  sops = {
    # Point to the age key cloned manually by the user.
    age.keyFile = config.home.homeDirectory + "/nix-secret/key.age";

    defaultSopsFile = ../secrets/secrets.yaml;
    validateSopsFiles = false;

    secrets = {
      "git_email_config" = { };
      "google_env" = { };
    };
  };
}
