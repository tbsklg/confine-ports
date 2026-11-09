# zandy-ports

Presets and gateways for [zandy](https://github.com/tbsklg/zandy.nix). zandy is the base: the launcher, the broker, `mkSandboxEnv` and `mkGateway`. This repo holds what runs on it, and is updated on its own.

## Use

zandy's template plugs this repo in as the `ports` input. See the [zandy quickstart](https://github.com/tbsklg/zandy.nix#quickstart). To add it to an existing flake:

```nix
inputs.ports.url = "github:tbsklg/zandy-ports";
inputs.ports.inputs.zandy.follows = "zandy";
```

## Presets

| Preset | Program |
|---|---|
| `ports.presets.claude` | Claude Code |
| `ports.presets.opencode` | opencode |

A preset doesn't open the project directory. Combine it with the project rules:

```nix
preset = ports.presets.claude // { rules = ports.rules.project ++ ports.presets.claude.rules; };
```

## Project rules

`ports.rules.project` lets the agent read the whole project and write everything in it except dot paths, at any depth: `.envrc`, `.git`, `.vscode`, `.github` and the like. Those are files your tools read or run on their own, outside the sandbox.

- **Open a dot path** with `filesystem.allowWrite`, e.g. `[ ".zig-cache" ]`. Only open what no tool runs: build caches are fine, `.vscode` or `.github` are not.
- **Let the agent commit** with `filesystem.allowWrite = [ ".git" ]`. That opens all of `.git`, including `.git/config` and `.git/hooks`, which git runs as you. Without it, the agent can still run `git status` and `git diff`, and you commit.
- **A project inside a dot directory**, like `~/.dotfiles/foo`, is read-only as a whole, because the rule checks the full path.
- **A project under `$TMPDIR` or `/tmp`** isn't protected by the rule when the preset allows writing there, as the claude preset does.

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
