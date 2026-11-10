# gitlab

```toml
[adapters.gitlab]
host = "gitlab.example.com"
```

Runs `glab` with your login from `glab auth login`.

**Open.** It passes any arguments to glab, so the program can do whatever your token can, and can print it with `glab config get token`. Use it only with a token you would hand the program directly.
