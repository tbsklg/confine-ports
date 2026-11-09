{ mkGateway }:
{ service ? "anthropic-api-key" }:
mkGateway {
  name = "anthropic";
  host = "api.anthropic.com";
  headers.X-Api-Key = [ "{env.ANTHROPIC_API_KEY}" ];
  secrets.ANTHROPIC_API_KEY.keychain = { inherit service; };
}
