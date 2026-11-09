# TODO

- **Adapters.** GitLab and AWS with narrow methods that can't print the token, no free `args`.
- **Project template.** `nix flake init -t zandy-ports#project` for a flake in its own directory next to a project, sharing the toolchain with a devShell.
- **OpenAI in a preset.** No preset sets `gatewayEnv.openai` yet; opencode configures providers in its config file.
- **aws-sigv4-proxy 1.13.1.** Pinned to 1.13 until nixpkgs has Go 1.26.9.
- **Preset probe.** Check that each preset denies its own project config, e.g. `.claude/` and `.mcp.json`; zandy's probe now covers only the base.
