{
  description = "zandy-ports: presets for zandy";

  inputs.zandy.url = "github:tbsklg/zandy.nix";
  inputs.nixpkgs.follows = "zandy/nixpkgs";

  outputs = { zandy, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
      };
      presets = {
        claude = import ./presets/claude.nix;
        opencode = import ./presets/opencode.nix;
      };
    in
    {
      inherit presets;

      templates.default = {
        path = ./templates/default;
        description = "A zandy sandbox env: run with `nix run`, install with `nix profile add`";
      };

      checks.${system} = builtins.mapAttrs
        (name: preset: zandy.lib.mkSandboxEnv { inherit pkgs name preset; })
        presets;
    };
}
