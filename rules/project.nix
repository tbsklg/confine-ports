[
  { action = "allow"; operation = "file_all"; filter = { subpath = { param = "CWD"; }; }; }
  { action = "deny"; operation = "file_write_all"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.envrc"; }; }; }; }
  { action = "deny"; operation = "file_write_create"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.envrc"; }; }; }; }
  { action = "deny"; operation = "file_write_data"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.envrc"; }; }; }; }
  { action = "deny"; operation = "file_write_all"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.git"; }; }; }; }
  { action = "deny"; operation = "file_write_create"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.git"; }; }; }; }
  { action = "deny"; operation = "file_write_data"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.git"; }; }; }; }
  { action = "deny"; operation = "file_write_all"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.git/config"; }; }; }; }
  { action = "deny"; operation = "file_write_create"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.git/config"; }; }; }; }
  { action = "deny"; operation = "file_write_data"; filter = { literal = { param_append = { param = "CWD"; suffix = "/.git/config"; }; }; }; }
  { action = "deny"; operation = "file_write_all"; filter = { subpath = { param_append = { param = "CWD"; suffix = "/.git/hooks"; }; }; }; }
  { action = "deny"; operation = "file_write_create"; filter = { subpath = { param_append = { param = "CWD"; suffix = "/.git/hooks"; }; }; }; }
  { action = "deny"; operation = "file_write_data"; filter = { subpath = { param_append = { param = "CWD"; suffix = "/.git/hooks"; }; }; }; }
]
