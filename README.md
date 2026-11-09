# zandy-ports

Presets and gateways for [zandy](https://github.com/tbsklg/zandy.nix). zandy is the base: the launcher, the broker, `mkSandboxEnv` and `mkGateway`. This repo holds what runs on it, and is updated on its own.

## Quickstart

```sh
mkdir ~/sandboxes && cd ~/sandboxes
nix flake init -t github:tbsklg/zandy-ports
git init && git add -A
cd your-project
nix run ~/sandboxes
```

The template uses your Claude login. Run `claude` once outside zandy and log in.

## Presets

| Preset | Program |
|---|---|
| `ports.presets.claude` | Claude Code |
| `ports.presets.opencode` | opencode |

## Model backends

One gateway per env. It adds the credentials outside the sandbox and forwards to one fixed upstream.

### Bedrock

```nix
gateway = ports.gateways.bedrock { profile = "acme-bedrock"; region = "eu-west-1"; };
```

Needs an AWS profile with Bedrock access in `~/.aws/config`, logged in with e.g. `aws sso login --profile acme-bedrock`. If it fails with `refresh cached SSO token failed … InvalidGrantException`, the SSO session expired; log in again.

### Anthropic API key

```nix
gateway = ports.gateways.anthropic { };
```

Needs the API key, stored with `zandy-claude --zandy-secret anthropic-api-key`.

### Claude subscription

```nix
gateway = ports.gateways.anthropicOauth { };
```

Uses your Claude login. zandy reads the token from your login keychain at start.

### OpenAI

```nix
gateway = ports.gateways.openai { };
```

Needs the API key, stored with `zandy-claude --zandy-secret openai-api-key`. Set `host` for an OpenAI-compatible API other than `api.openai.com`. No preset uses this gateway yet.

For a backend not listed here, build one with [`zandy.lib.mkGateway`](https://github.com/tbsklg/zandy.nix/blob/main/docs/README.md#your-own-gateway).

## Rules for ports

- A preset allows only what its program needs. Nothing that runs outside the sandbox, like the program's own project config, is writable.
- A gateway forwards to one fixed host and adds its credential there, never inside the sandbox.
- An adapter has narrow methods with `string` and `choice` params. No `list` param that passes arguments to a tool holding a credential: the agent could make the tool print it.

## Update

```sh
nix flake update ports && nix profile upgrade --all
```

`ports` follows your `zandy` input, so both use the same base.
