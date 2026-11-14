#!/usr/bin/env bash
# Usage: bash google_scholar_crawler/update_local.sh [--push]
set -euo pipefail

if [[ $# -gt 1 || ($# -eq 1 && "$1" != "--push") ]]; then
  echo "Usage: bash google_scholar_crawler/update_local.sh [--push]" >&2
  exit 2
fi
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(git -C "$script_dir" rev-parse --show-toplevel)"
venv_dir="$repo_dir/.venv-scholar"
python_bin="${PYTHON:-python3}"
if [[ ! -x "$venv_dir/bin/python" ]]; then
  "$python_bin" -m venv "$venv_dir"
fi
if command -v uv >/dev/null 2>&1; then
  uv pip install --python "$venv_dir/bin/python" -r "$script_dir/requirements.txt"
else
  "$venv_dir/bin/python" -m pip install --disable-pip-version-check -r "$script_dir/requirements.txt"
fi
export GOOGLE_SCHOLAR_ID="${GOOGLE_SCHOLAR_ID:-AIxm9uAAAAAJ}"
# Local failures must stop publication, even when launched from a CI-like shell.
unset GITHUB_ACTIONS GITHUB_OUTPUT GITHUB_STEP_SUMMARY
update_dir="$(mktemp -d "${TMPDIR:-/tmp}/scholar-update.XXXXXX")"
trap 'rm -rf "$update_dir"' EXIT
cd "$update_dir"
"$venv_dir/bin/python" "$script_dir/main.py"
"$venv_dir/bin/python" - <<'PY'
import json
from pathlib import Path
snapshot = json.loads(Path('results/gs_data.json').read_text())
badge = json.loads(Path('results/gs_data_shieldsio.json').read_text())
assert snapshot['scholar_id'] == __import__('os').environ['GOOGLE_SCHOLAR_ID'], 'Unexpected author ID'
assert isinstance(snapshot['citedby'], int) and snapshot['citedby'] >= 0, 'Invalid citation count'
assert isinstance(snapshot['publications'], dict) and snapshot['updated'], 'Incomplete snapshot'
assert badge['schemaVersion'] == 1 and badge['message'] == str(snapshot['citedby']), 'Badge mismatch'
print(f"Validated: {snapshot['name']}, {snapshot['citedby']} citations, {len(snapshot['publications'])} publications")
PY
mkdir -p "$script_dir/results"
cp results/gs_data.json results/gs_data_shieldsio.json "$script_dir/results/"
echo "Local data saved to $script_dir/results"
if [[ "${1:-}" != "--push" ]]; then
  echo "Run again with --push to fetch and publish citation data."
  exit 0
fi
git clone --quiet --single-branch --branch google-scholar-stats "$(git -C "$repo_dir" remote get-url origin)" "$update_dir/publish"
cp results/gs_data.json results/gs_data_shieldsio.json "$update_dir/publish/"
cd "$update_dir/publish"
git config user.name "$(git -C "$repo_dir" var GIT_AUTHOR_IDENT | sed 's/ <.*//')"
git config user.email "$(git -C "$repo_dir" var GIT_AUTHOR_IDENT | sed 's/.*<\([^>]*\)>.*/\1/')"
git add gs_data.json gs_data_shieldsio.json
if git diff --cached --quiet; then
  echo "Citation data is unchanged."
  exit 0
fi
git commit -m "Update citation data from local fetch"
git push origin HEAD:google-scholar-stats
echo "Citation data published successfully."
