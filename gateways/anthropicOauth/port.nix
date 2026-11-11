{ mkGateway, ... }: {
  description = "Anthropic API with your Claude subscription login";
  args.service = { type = "string"; default = "Claude Code-credentials"; description = "Login keychain item that holds the Claude login"; };
  build = { service }: mkGateway {
    name = "anthropic";
    host = "api.anthropic.com";
    headers.Authorization = [ "Bearer {env.CONFINE_GATEWAY_TOKEN}" ];
    addHeaders.anthropic-beta = [ "oauth-2025-04-20" ];
    secrets.CONFINE_GATEWAY_TOKEN.keychain = {
      inherit service;
      store = "login";
      field = [ "claudeAiOauth" "accessToken" ];
    };
  };
}
