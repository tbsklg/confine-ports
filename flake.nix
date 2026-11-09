{
  description = "zandy-ports: presets and gateways for zandy";

  inputs.zandy.url = "github:tbsklg/zandy.nix";
  inputs.nixpkgs.follows = "zandy/nixpkgs";

  outputs = { zandy, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
      };
      inherit (zandy.lib) mkGateway;
      presets = {
        claude = import ./presets/claude.nix;
        opencode = import ./presets/opencode.nix;
      };
      rules.project = import ./rules/project.nix;
      withProject = preset: preset // { rules = rules.project ++ preset.rules; };
      gateways = {
        bedrock = import ./gateways/bedrock.nix;
        anthropic = import ./gateways/anthropic.nix { inherit mkGateway; };
        anthropicOauth = import ./gateways/anthropic-oauth.nix { inherit mkGateway; };
        openai = import ./gateways/openai.nix { inherit mkGateway; };
      };
      gatewayChecks = {
        bedrock = gateways.bedrock { profile = "check"; region = "eu-west-1"; };
        anthropic = gateways.anthropic { };
        anthropicOauth = gateways.anthropicOauth { };
        openai = gateways.openai { };
      };
    in
    {
      inherit presets gateways rules;

      checks.${system} =
        builtins.mapAttrs (name: preset: zandy.lib.mkSandboxEnv { inherit pkgs name; preset = withProject preset; }) presets
        // nixpkgs.lib.mapAttrs' (name: gateway: {
          name = "claude-${name}";
          value = zandy.lib.mkSandboxEnv { inherit pkgs gateway; name = "claude-${nixpkgs.lib.toLower name}"; preset = withProject presets.claude; };
        }) gatewayChecks;
    };
}
