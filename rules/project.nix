[
  { action = "allow"; operation = "file_read_all"; filter = { subpath = { param = "CWD"; }; }; }
  { action = "allow"; operation = "file_all"; filter = { require_all = [ { subpath = { param = "CWD"; }; } { require_not = { regex = "/\\."; }; } ]; }; }
]
