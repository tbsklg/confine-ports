# opencode

opencode. It configures providers in its own config file; no gateway sets its env yet.

The agent can't write `~/.config/opencode/opencode.json`, `~/.config/opencode/plugin`, and in the project `.opencode/`, `opencode.json` and `opencode.jsonc`.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `operation not permitted mkdir '/var/folders/…'` | Start opencode once without zandy |
