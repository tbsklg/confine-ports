#!/usr/bin/env bash
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
project=$(mktemp -d)
trap 'rm -rf "$project"' EXIT

nix build "$repo#project-probe" --print-build-logs --out-link "$project/result" "$@"

cd "$project"
git init -q
touch flake.nix .envrc
"$project/result/bin/zandy-project-probe"
