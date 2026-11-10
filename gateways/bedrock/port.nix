_: {
  description = "Amazon Bedrock, signed with an AWS profile";
  args = {
    profile = { type = "string"; example = "acme-bedrock"; description = "AWS profile with Bedrock access"; };
    region = { type = "string"; example = "eu-west-1"; description = "AWS region of Bedrock"; };
  };
  build = { profile, region }: pkgs:
    let
      proxy = pkgs.callPackage ./aws-sigv4-proxy.nix { };
    in
    {
      name = "bedrock";
      inherit region;
      argv = [ "${proxy}/bin/aws-sigv4-proxy" "--port" "127.0.0.1:{port}" "--name" "bedrock" "--region" region "--host" "bedrock-runtime.${region}.amazonaws.com" "--upstream-url-scheme" "https" ];
      env.AWS_PROFILE = profile;
    };
}
