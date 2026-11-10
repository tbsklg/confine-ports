# bedrock

```toml
[gateway.bedrock]
profile = "acme-bedrock"
region = "eu-west-1"
```

Needs an AWS profile with Bedrock access in `~/.aws/config`, logged in with e.g. `aws sso login --profile acme-bedrock`. If it fails with `refresh cached SSO token failed … InvalidGrantException`, the SSO session expired; log in again.

A few info lines on stderr at start come from `aws-sigv4-proxy` and are harmless. It is pinned to 1.13 until nixpkgs has Go 1.26.9.
