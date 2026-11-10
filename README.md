# zandy-ports

Presets, adapters and gateways for [zandy](https://github.com/tbsklg/zandy.nix). zandy is the base: the launcher, the broker, `mkSandboxEnv` and `mkGateway`. This repo holds what runs on it, and is updated on its own.

## Use

Start from the [zandy quickstart](https://github.com/tbsklg/zandy.nix#quickstart): its template plugs this repo in and you pick ports by name in `zandy.toml`.

```toml
preset = "claude"

[gateway.bedrock]
profile = "acme-bedrock"
region = "eu-west-1"

[adapters.gitlab]
host = "gitlab.example.com"
```

`ports.catalog` is what the template hands to zandy: every port below, with the project rules on every preset. From Nix, use the ports directly: `ports.presets.claude`, `ports.gateways.bedrock { … }`, `ports.adapters.gitlab { … }`, `ports.rules.project`.

## Ports

| Port | What |
|---|---|
| [presets/claude](presets/claude) | Claude Code |
| [presets/opencode](presets/opencode) | opencode |
| [presets/shell](presets/shell) | bash, for any command |
| [gateways/anthropicOauth](gateways/anthropicOauth) | Anthropic API with your Claude subscription login |
| [gateways/anthropic](gateways/anthropic) | Anthropic API with an API key |
| [gateways/bedrock](gateways/bedrock) | Amazon Bedrock with an AWS profile |
| [gateways/openai](gateways/openai) | OpenAI or a compatible API with an API key |
| [adapters/gitlab](adapters/gitlab) | GitLab via glab, **open** |
| [adapters/aws](adapters/aws) | AWS via the aws CLI, **open** |

## Project rules

`ports.rules.project` lets the program read the whole project and write everything in it except dot paths, at any depth: `.envrc`, `.git`, `.vscode`, `.github` and the like. Those are files your tools read or run on their own, outside the sandbox.

- **Open a dot path** with `filesystem.allowWrite`, e.g. `[".zig-cache"]`. Only open what no tool runs: build caches are fine, `.vscode` or `.github` are not.
- **Let the program commit** with `filesystem.allowWrite = [".git"]`. That opens all of `.git`, including `.git/config` and `.git/hooks`, which git runs as you. Without it, the program can still run `git status` and `git diff`, and you commit.
- **A project inside a dot directory**, like `~/.dotfiles/foo`, is read-only as a whole, because the rule checks the full path.
- **A project under `$TMPDIR` or `/tmp`** isn't protected by the rule when the preset allows writing there, as the claude preset does.

## Writing a port

A port is a directory under `presets/`, `gateways/` or `adapters/` with a `port.nix` and a `README.md`. Nothing else needs editing: the catalog, and so the TOML names, the schema and the checks, come from the tree.

```nix
{ mkGateway, ... }: {
  description = "One line";
  args.host = { type = "string"; default = "example.com"; description = "Host of the API"; };
  build = { host }: mkGateway { … };
}
```

`port.nix` gets `zandy.lib`. `args` types are `string` and `list` (of strings); each has a `default` or an `example`, which the checks build with. `build` takes exactly the declared args. `unfree` lists unfree packages the port needs, e.g. `[ "claude-code" ]`. A preset's `build` returns the preset, a gateway's or adapter's what `mkSandboxEnv` takes.

`nix flake check` checks this layout and the last of these rules:

- A preset allows only what its program needs. Nothing that runs outside the sandbox, like the program's own project config, is writable.
- A gateway forwards to one fixed host and adds its credential there, never inside the sandbox.
- An adapter has narrow methods with `string` and `choice` params. A `list` param passes anything to the tool, which can then print its credential; such a port must say `open = true`, which its schema entry shows.

## Update

In your env's directory:

```sh
nix flake update && nix profile upgrade --all
```

`ports` follows your `zandy` input, so both use the same base. `nix flake update ports` updates only the ports, `nix flake update zandy` only the base. Rebuild the schema afterwards: `nix build .#schema -o zandy.schema.json`.
