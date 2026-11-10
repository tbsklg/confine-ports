{ mkGateway, ... }: {
  description = "OpenAI or an OpenAI-compatible API with an API key";
  args = {
    service = { type = "string"; default = "openai-api-key"; description = "zandy keychain item that holds the API key"; };
    host = { type = "string"; default = "api.openai.com"; description = "Host of the API"; };
  };
  build = { service, host }: mkGateway {
    name = "openai";
    inherit host;
    headers.Authorization = [ "Bearer {env.OPENAI_API_KEY}" ];
    secrets.OPENAI_API_KEY.keychain = { inherit service; };
  };
}
