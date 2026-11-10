{
  description = "zandy-ports: presets, adapters and gateways for zandy";

  inputs.zandy.url = "github:tbsklg/zandy.nix";
  inputs.nixpkgs.follows = "zandy/nixpkgs";

  outputs = { zandy, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      system = "aarch64-darwin";
      tree = import ./lib/catalog.nix { inherit lib zandy; };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) (lib.concatMap (port: port.unfree or [ ]) (lib.attrValues tree.presets));
      };
      inherit (zandy.lib) mkSandboxEnv;

      rules.project = import ./rules/project.nix;
      withProject = preset: preset // { rules = rules.project ++ preset.rules; };
      catalog = tree // {
        presets = lib.mapAttrs (_: port: port // { call = args: withProject (port.call args); }) tree.presets;
      };
      claude = catalog.presets.claude.call { };
      problems = import ./lib/portcheck.nix { inherit lib pkgs; catalog = tree; };

      envName = kind: name: "${kind}-${lib.toLower name}";
      portChecks = kind: build: lib.mapAttrs' (name: port: {
        name = envName kind name;
        value = mkSandboxEnv ({ inherit pkgs; name = envName kind name; preset = claude; } // build port);
      }) catalog.${kind};
    in
    {
      presets = lib.mapAttrs (_: port: port.call { }) tree.presets;
      gateways = lib.mapAttrs (_: port: port.call) tree.gateways;
      adapters = lib.mapAttrs (_: port: port.call) tree.adapters;
      inherit rules catalog;

      packages.${system}.project-probe = import ./tests/project-test.nix { inherit pkgs mkSandboxEnv; project = rules.project; };

      checks.${system} =
        portChecks "presets" (port: { preset = port.call { }; })
        // portChecks "gateways" (port: { gateway = port.call port.example; })
        // portChecks "adapters" (port: { adapters = [ (port.call port.example) ]; })
        // {
          portcheck = pkgs.runCommand "portcheck" { } (
            if problems == [ ] then "touch $out"
            else "echo ${lib.escapeShellArg (lib.concatStringsSep "\n" problems)} >&2; exit 1"
          );
          config = zandy.lib.fromConfig { inherit system catalog; config = ./tests/zandy.toml; };
          schema = zandy.lib.schemaFor { inherit system catalog; };
        };
    };
}
