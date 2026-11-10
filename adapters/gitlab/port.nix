_: {
  description = "GitLab via glab, with your glab login";
  open = true;
  args.host = { type = "string"; default = "gitlab.com"; description = "GitLab host"; };
  build = { host }: pkgs: {
    name = "gitlab";
    package = pkgs.glab;
    binary = "glab";
    setEnv.GITLAB_HOST = host;
    capabilities = [
      {
        name = "cli";
        description = "Run a glab command with the user's glab login. What it may do is decided by the token's scopes. args are the glab arguments, e.g. [\"issue\", \"list\", \"--repo\", \"group/name\"].";
        params = [
          { name = "args"; kind = "list"; description = "Arguments passed to glab, one entry per argument"; }
        ];
        argv = [ "{args}" ];
      }
    ];
  };
}
