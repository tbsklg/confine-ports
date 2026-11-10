# TODO

- **CI against zandy main.** Run `nix flake check --override-input zandy github:tbsklg/zandy.nix` on every push, so a base change that breaks a port shows up here before users combine them.
- **Narrow adapters.** GitLab and AWS pass free `args`, so the program can make the tool print its token. Replace them with narrow methods.
- **OpenAI in a preset.** No preset sets `gatewayEnv.openai` yet; opencode configures providers in its config file.
- **aws-sigv4-proxy 1.13.1.** Pinned to 1.13 until nixpkgs has Go 1.26.9.
- **Preset probe.** Check that each preset denies its own project config, e.g. `.claude/` and `.mcp.json`; zandy's probe now covers only the base.
- **shell without wrapper.** Drop the bash wrapper that sets `NIX_SSL_CERT_FILE` and `SSL_CERT_FILE` once zandy has `sandboxEnv`; set them in the preset instead.
- **Projects under /tmp.** Presets that allow writing `/private/tmp` or `$TMPDIR` lift the dot-path protection for projects there. Narrow the temp rules, e.g. to a per-session directory.
