{ pkgs, mkSandboxEnv, project }:
mkSandboxEnv {
  inherit pkgs;
  name = "project-probe";
  preset = {
    name = "project-probe";
    packages = pkgs: [ pkgs.bash pkgs.coreutils ];
    env = [ "HOME" "TMPDIR" "USER" ];
    rules = project ++ [
      { action = "allow"; operation = "process_fork"; }
      { action = "allow"; operation = "sysctl_all"; }
      { action = "allow"; operation = "file_ioctl"; }
      { action = "allow"; operation = "file_read_metadata"; }
      { action = "allow"; operation = "file_map_executable"; }
      { action = "allow"; operation = "file_all"; filter = { literal = { literal = "/dev/null"; }; }; }
      { action = "allow"; operation = "file_read_data"; filter = { literal = { literal = "/"; }; }; }
    ];
  };
  filesystem.allowWrite = [ ".zandy-allowed" ".envrc" ];
  packages = [ (pkgs.writeShellScriptBin "project-probe" (builtins.readFile ./project-probe.sh)) ];
}
