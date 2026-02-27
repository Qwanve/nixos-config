{config, pkgs, ...}:
{
  security.shadow.enable = false;
  security.sudo.enable = false;
  security.sudo-rs.enable = true;

  security.wrappers = {
    su = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.sudo-rs}/bin/su";
    };
  };

  security.pam.services = {
    su = {
      rootOK = true;
      forwardXAuth = true;
      logFailures = true;
    };
  };
}
