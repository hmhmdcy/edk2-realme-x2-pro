#!/bin/bash
set -u

LINUX_ROOT="${X2PRO_LINUX_ROOT:-${1:-}}"
if [ -z "$LINUX_ROOT" ]; then
  echo "Usage: $0 /path/to/x2pro-linux (or set X2PRO_LINUX_ROOT)" >&2
  exit 2
fi

UPSTREAM_DIR="${LINUX_ROOT}/upstream"
KERNEL_DIR="${LINUX_ROOT}/linux"
if [ ! -d "$UPSTREAM_DIR" ]; then
  echo "Missing kernel remote checkout: $UPSTREAM_DIR" >&2
  exit 2
fi
if [ ! -d "$KERNEL_DIR" ]; then
  echo "Missing kernel source checkout: $KERNEL_DIR" >&2
  exit 2
fi

cd "$UPSTREAM_DIR" || exit 1
if ! command -v gh >/dev/null 2>&1 || ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI login required: gh auth login" >&2
  exit 1
fi
api_json="$(mktemp)"
trap 'rm -f "$api_json"' EXIT

echo "=== A) no-proxy remote probe ==="
timeout 20 git -c http.proxy= -c https.proxy= ls-remote up HEAD 2>&1 | head -2
echo "rc=$?"

echo "=== B) default remote probe ==="
timeout 20 git ls-remote up HEAD 2>&1 | head -2
echo "rc=$?"

echo "=== C) upstream commit lookup ==="
gh api repos/torvalds/linux/commits/a90ee4305c4a5df72c11b31dacfdc76e00fcf78a > "$api_json"
python3 - "$api_json" <<'PY'
import json, sys
d=json.load(open(sys.argv[1]))
c=d.get('commit')
if not c:
    print("API response:", str(d)[:200]); raise SystemExit
print("sha      :", d.get('sha'))
print("tree     :", c['tree']['sha'])
print("parents  :", [p['sha'] for p in d.get('parents',[])])
a,cm=c['author'],c['committer']
print("author   :", a['name'], "<%s>"%a['email'], a['date'])
print("committer:", cm['name'], "<%s>"%cm['email'], cm['date'])
print("msg first:", c['message'].splitlines()[0])
print("msg lines:", len(c['message'].splitlines()))
PY

echo "=== D) local baseline tree ==="
git -C "$KERNEL_DIR" rev-parse 'b0630f810^{tree}'
git -C "$KERNEL_DIR" log -1 --format='%T%n%an <%ae> %ad%n%cn <%ce> %cd%n%s' b0630f810
