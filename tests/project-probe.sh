#!/usr/bin/env bash
set -u

failed=0

outcome() {
  local out
  if out=$("$@" 2>&1); then echo allowed
  elif [[ $out == *"not permitted"* ]]; then echo denied
  else echo missing
  fi
}

can_write() { : >"$1" && rm -f -- "$1"; }
can_mkdir() { mkdir -- "$1" && rmdir -- "$1"; }
can_rename() { mv -- "$1" "$2" && mv -- "$2" "$1"; }

expect() {
  local want=$1 label=$2 got
  shift 2
  got=$(outcome "$@")
  if [[ $got == "$want" ]]; then echo "PASS   $want  $label"
  else echo "FAIL   $want  $label  (was: $got)"; failed=1
  fi
}

echo "--- project"
mkdir -p ./zandy-probe-dir
expect allowed "write a file in the project" can_write ./zandy-probe
expect allowed "write a file in a subdirectory" can_write ./zandy-probe-dir/zandy-probe
expect denied "write git objects" can_write ./.git/objects/zandy-probe
expect denied "write git refs" can_write ./.git/refs/heads/zandy-probe
expect denied "write a dot file" can_write ./.zandy-probe
expect allowed "write a dot file in allowWrite" can_write ./.zandy-allowed
expect allowed "write .envrc in allowWrite" can_write ./.envrc
expect denied "write .envrc in a subdirectory" can_write ./zandy-probe-dir/.envrc
expect denied "create .git in a subdirectory" can_mkdir ./zandy-probe-dir/.git
expect denied "write .git/config" can_write ./.git/config
expect denied "write .git/hooks/" can_write ./.git/hooks/zandy-probe
expect denied "write anything else in .git" can_write ./.git/zandy-probe
expect denied "rename .git" can_rename ./.git ./zandy-probe-git
rm -rf ./zandy-probe-dir

exit $failed
