{
  name = "shell";
  binary = "shell";
  packages = pkgs: [
    (pkgs.writeShellScriptBin "shell" ''
      export NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      exec ${pkgs.bash}/bin/bash --norc "$@"
    '')
    pkgs.bash
    pkgs.coreutils
  ];
  env = [ "HOME" "TMPDIR" "USER" "TERM" "COLORTERM" "LANG" "LC_ALL" ];

  rules = [
    { action = "allow"; operation = "process_exec"; filter = { literal = { literal = "/bin/sh"; }; }; }
    { action = "allow"; operation = "process_fork"; }
    { action = "allow"; operation = "sysctl_all"; }
    { action = "allow"; operation = "file_ioctl"; }
    { action = "allow"; operation = "file_read_metadata"; }
    { action = "allow"; operation = "file_map_executable"; }
    { action = "allow"; operation = "process_info_all"; filter = { target = "same-sandbox"; }; }
    { action = "allow"; operation = "signal"; filter = { target = "same-sandbox"; }; }
    { action = "allow"; operation = "network_outbound"; filter = { remote_tcp = "*:443"; }; }
    { action = "allow"; operation = "network_outbound"; filter = { remote_unix_socket = { literal = "/private/var/run/mDNSResponder"; }; }; }
    { action = "allow"; operation = "mach_lookup"; filter = { global_name = "com.apple.bsd.dirhelper"; }; }
    { action = "allow"; operation = "mach_lookup"; filter = { global_name = "com.apple.system.opendirectoryd.libinfo"; }; }
    { action = "allow"; operation = "file_all"; filter = { literal = { literal = "/dev/null"; }; }; }
    { action = "allow"; operation = "file_read_data"; filter = { literal = { literal = "/"; }; }; }
    { action = "allow"; operation = "file_read_data"; filter = { subpath = { literal = "/private/var"; }; }; }
    { action = "allow"; operation = "file_write_all"; filter = { subpath = { param = "TMPDIR"; }; }; }
    { action = "allow"; operation = "file_read_data"; filter = { subpath = { literal = "/private/tmp"; }; }; }
    { action = "allow"; operation = "file_write_all"; filter = { subpath = { literal = "/private/tmp"; }; }; }
    { action = "deny"; operation = "file_all"; filter = { subpath = { literal = "/private/tmp/com.apple.launchd"; }; }; }
    { action = "deny"; operation = "file_all"; filter = { subpath = { literal = "/private/var/db"; }; }; }
    { action = "deny"; operation = "file_all"; filter = { subpath = { literal = "/private/var/root"; }; }; }
  ];
}
