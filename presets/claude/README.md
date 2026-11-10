# claude

Claude Code. Needs a gateway; `anthropicOauth`, `anthropic` and `bedrock` work.

The agent can't write its own config that runs outside the sandbox: `~/.claude/settings.json`, `~/.claude/settings.local.json`, `~/.claude/plugins`, and in the project `.claude/` and `.mcp.json`.

## Troubleshooting

| Symptom | Fix |
|---|---|
| claude tries to resolve AWS credentials inside the sandbox | Remove `AWS_PROFILE` and `awsCredentialExport` from `~/.claude/settings.json` |
