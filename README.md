# zandy-ports

Presets for [zandy](https://github.com/tbsklg/zandy.nix). zandy is the base: the launcher, the broker, the gateways and `mkSandboxEnv`. This repo holds what runs on it, and is updated on its own.

## Quickstart

```sh
mkdir ~/sandboxes && cd ~/sandboxes
nix flake init -t github:tbsklg/zandy-ports
git init && git add -A
cd your-project
nix run ~/sandboxes
```

The template uses your Claude login. Run `claude` once outside zandy and log in. For other model backends, see the [zandy docs](https://github.com/tbsklg/zandy.nix/blob/main/docs/README.md#model-backends).

## Presets

| Preset | Program |
|---|---|
| `ports.presets.claude` | Claude Code |
| `ports.presets.opencode` | opencode |

## Rules for ports

- A preset allows only what its program needs. Nothing that runs outside the sandbox, like the program's own project config, is writable.
- An adapter has narrow methods with `string` and `choice` params. No `list` param that passes arguments to a tool holding a credential: the agent could make the tool print it.

## Update

```sh
nix flake update ports && nix profile upgrade --all
```

`ports` follows your `zandy` input, so both use the same base.
