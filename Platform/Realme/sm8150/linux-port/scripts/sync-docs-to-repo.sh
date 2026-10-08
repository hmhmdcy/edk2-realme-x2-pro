#!/bin/bash
# Sync the top-level documents of the Windows working copy into the repo mirror,
# run the health check, commit and push.
#   usage: sync-docs-to-repo.sh ["commit message"]
# linux-port/ is handled by mirror-linux-port.sh; build artifacts are never copied.
set -u
W="/mnt/e/RealmeX2Pro edk2"
RK=/home/cy122/edk2-samurai/repo
P="$RK/Platform/Realme/sm8150"
MSG="${1:-docs: sync the working copy into the repo}"

echo "=== copy ==="
for f in README.md HANDOVER-NEXT.md EUD.md BINARIES.md DOCS-INDEX.md DIAG-CAPTURE.md EVALUATION-AND-PLAN.md; do
  if [ -f "$W/$f" ]; then cp -f "$W/$f" "$P/$f" && echo "  $f"; fi
done
for d in archive reference sessions; do
  if [ -d "$W/$d" ]; then mkdir -p "$P/$d"; cp -r -f "$W/$d/." "$P/$d/"; echo "  $d/"; fi
done

echo
echo "=== health check ==="
bash "$W/linux-port/scripts/docs-health-check.sh" || { echo "health check failed - not committing"; exit 1; }

echo
echo "=== commit ==="
cd "$RK"
git add -A Platform/Realme/sm8150
if git diff --cached --quiet; then echo "nothing to commit"; exit 0; fi
git commit -q -m "$MSG"
git log --oneline -2
git show --stat --oneline HEAD | head -12

echo
echo "=== push (retries: the local proxy is flaky) ==="
for i in 1 2 3; do
  echo "--- attempt $i ---"
  if git push fork master 2>&1 | tail -3; then break; fi
  sleep 8
done
git status --short