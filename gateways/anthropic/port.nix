{ mkGateway, ... }: {
  description = "Anthropic API with an API key";
  args.service = { type = "string"; default = "anthropic-api-key"; description = "zandy keychain item that holds the API key"; };
  build = { service }: mkGateway {
    name = "anthropic";
    host = "api.anthropic.com";
    headers.X-Api-Key = [ "{env.ANTHROPIC_API_KEY}" ];
    secrets.ANTHROPIC_API_KEY.keychain = { inherit service; };
  };
}
