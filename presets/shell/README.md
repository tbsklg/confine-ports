# shell

bash with coreutils, for any command. Add what the command needs to `packages`.

```toml
name = "shell"
preset = "shell"
packages = ["nodejs"]
```

```sh
cd your-project
confine-shell npm install --cache "$TMPDIR/npm"
confine-shell                     # interactive
```

The command can read the project and write it except dot paths, write `$TMPDIR` and `/private/tmp`, and connect to port 443 and DNS. It can't read or write the rest of your home. No gateway is needed.

`curl` and other tools built with Nix find the CA bundle through `NIX_SSL_CERT_FILE` and `SSL_CERT_FILE`, which the preset sets.

## Troubleshooting

| Symptom | Fix |
|---|---|
| A tool fails writing its cache in `~`, e.g. npm's `EPERM … ~/.npm` | Point the cache at `$TMPDIR`, e.g. `npm --cache "$TMPDIR/npm"`, or add the directory to `[filesystem] allowWrite` |
