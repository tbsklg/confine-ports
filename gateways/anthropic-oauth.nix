{ mkGateway }:
{ service ? "Claude Code-credentials" }:
mkGateway {
  name = "anthropic";
  host = "api.anthropic.com";
  headers.Authorization = [ "Bearer {env.ZANDY_GATEWAY_TOKEN}" ];
  addHeaders.anthropic-beta = [ "oauth-2025-04-20" ];
  secrets.ZANDY_GATEWAY_TOKEN.keychain = {
    inherit service;
    store = "login";
    field = [ "claudeAiOauth" "accessToken" ];
  };
}
