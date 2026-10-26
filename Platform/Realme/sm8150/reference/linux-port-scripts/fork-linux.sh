#!/bin/bash
# Historical helper: inspect Linux v7.3-rc6 and fork torvalds/linux into hmhmdcy.
set -u

if ! command -v gh >/dev/null 2>&1 || ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI login required: gh auth login" >&2
  exit 1
fi
api_json="$(mktemp)"
trap 'rm -f "$api_json"' EXIT

echo "=== inspect tag ==="
timeout 90 git ls-remote --tags https://github.com/torvalds/linux.git 'v7.3-rc6*' 2>&1 | head -5
echo "=== inspect commit a90ee4305c4a ==="
timeout 90 git ls-remote https://github.com/torvalds/linux.git a90ee4305c4a5df72c11b31dacfdc76e00fcf78a 2>&1 | head -3

echo "=== check fork ==="
gh api repos/hmhmdcy/realme-x2-pro-linux > "$api_json"
python3 -c "import json,sys;d=json.load(open(sys.argv[1]));print('exist:',d.get('full_name') or d.get('message'))" "$api_json"

echo "=== create fork ==="
gh api --method POST repos/torvalds/linux/forks > "$api_json"
python3 -c "import json,sys;d=json.load(open(sys.argv[1]));print('fork:',d.get('full_name'),d.get('clone_url'),d.get('message'))" "$api_json"

echo "=== wait for fork ==="
for i in $(seq 1 30); do
  if gh api repos/hmhmdcy/realme-x2-pro-linux > "$api_json" 2>/dev/null; then
    echo "ready after ${i}0s"
    break
  fi
  sleep 10
done
python3 -c "import json,sys;d=json.load(open(sys.argv[1]));print('status:',d.get('full_name'),d.get('size'),'KB')" "$api_json"
