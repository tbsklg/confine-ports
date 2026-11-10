# aws

```toml
[adapters.aws]
profiles = ["acme-dev"]
```

Runs `aws` with one of `profiles`, logged in with e.g. `aws sso login --profile acme-dev`.

**Open.** It passes any arguments to aws, so the program can do whatever the profile can, and can print its credentials with `aws configure export-credentials`. Use it only with a profile you would hand the program directly, e.g. read-only.
