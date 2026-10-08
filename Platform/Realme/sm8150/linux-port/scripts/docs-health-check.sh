#!/bin/bash
# docs-health-check.sh - run after any documentation change.
# Checks: the slim handover keeps only sections 0-7, every former section 8-30
# has exactly one home, the archive is the verbatim pre-split file, and the
# Windows working copy and the repo mirror do not drift.
set -u
W="/mnt/e/RealmeX2Pro edk2"
RK=/home/cy122/edk2-samurai/repo
P="$RK/Platform/Realme/sm8150"
fail=0
say() { printf '%s\n' "$*"; }

say "== 1. HANDOVER-NEXT.md keeps sections 0-7, nothing older =="
have=$(grep -c '^## [0-7]\. ' "$W/HANDOVER-NEXT.md" || true)
bad=$(grep -cE '^## (8|9|1[0-9]|2[0-9]|30)\. ' "$W/HANDOVER-NEXT.md" || true)
say "   sections 0-7: $have (expect 8) | sections 8-30 still inline: $bad (expect 0)"
if [ "$have" != 8 ] || [ "$bad" != 0 ]; then fail=1; fi

say
say "== 2. every former section 8-30 lives in exactly one file =="
for n in $(seq 8 30); do
  c=$(grep -rl "^## $n\. " "$W/HANDOVER-NEXT.md" "$W/reference" "$W/sessions" "$W/linux-port/docs" 2>/dev/null | wc -l)
  if [ "$c" != 1 ]; then say "   section $n: found in $c files (expect 1)"; fail=1; fi
done
if [ "$fail" = 0 ]; then say "   ok: all 23 sections have exactly one home"; fi

say
say "== 3. archive equals the pre-split file in git =="
want=$(cat "$P/archive/HANDOVER-NEXT-full-2026-10-08.md" | sha256sum | cut -d' ' -f1)
got=$(sha256sum "$W/archive/HANDOVER-NEXT-full-2026-10-08.md" | cut -d' ' -f1)
say "   archive  $got"
say "   mirror   $want"
if [ "$want" = "$got" ]; then say "   ok: working copy and mirror agree"; else say "   WARN: the archive differs on the two sides"; fail=1; fi

say
say "== 4. Windows working copy vs repo mirror =="
for f in HANDOVER-NEXT.md README.md EUD.md BINARIES.md DOCS-INDEX.md SWD-JTAG.md RX-CONSOLE.md EVALUATION-AND-PLAN.md; do
  if [ -f "$W/$f" ] && [ -f "$P/$f" ]; then
    if ! diff -q "$W/$f" "$P/$f" >/dev/null; then say "   DRIFT: $f"; fail=1; fi
  else
    say "   missing on one side: $f"
  fi
done
for f in DIAG-CAPTURE.md; do
  if [ -e "$W/$f" ] || [ -e "$P/$f" ]; then
    say "   STALE: $f still exists - its content moved to sessions/2026-10-06-*.md"; fail=1
  fi
done

if [ -d "$W/linux-port" ]; then
  d=$(diff -rq "$W/linux-port" "$P/linux-port" 2>/dev/null | grep -v -e artifacts -e README-MIRROR.md || true)
  if [ -n "$d" ]; then say "   linux-port differences:"; printf '%s\n' "$d" | sed 's/^/     /'; fail=1; fi
fi
if [ "$fail" = 0 ]; then say "   ok: no drift"; fi

say
say "== 5. largest documents =="
find "$P" -name '*.md' -not -path '*/linux-port/docs/*' -printf '%7s  %p\n' | sort -rn | sed 's|'"$P"'/|   |' | head -8

say
say "== 6. top-level duplicate headings (a sign of a second copy) =="
grep -rh '^# ' "$P"/*.md 2>/dev/null | sort | uniq -d | sed 's/^/   /' || true

say
say "== 7. the Repo state block in the handover agrees with the repo =="
head=$(git -C "$RK" rev-parse --short HEAD)
doc=$(grep -m1 '^    master = ' "$W/HANDOVER-NEXT.md" | awk '{print $3}')
if git -C "$RK" merge-base --is-ancestor "$doc" HEAD 2>/dev/null; then
  say "   ok: the block names $doc, which is in $head"
else
  say "   OUT OF DATE: the block names $doc, which is not in the repo history"
  say "                (run linux-port/scripts/sync-docs-to-repo.sh - it regenerates the block)"
  fail=1
fi
want=$(git -C "$RK" rev-list --count origin/master..master)
got=$(grep -m1 'commits ahead of upstream origin/master' "$W/HANDOVER-NEXT.md" | grep -o '[0-9]\+' | head -1)
if [ "$want" = "$got" ]; then
  say "   ok: $got commits ahead of upstream origin/master"
else
  say "   OUT OF DATE: the handover says $got, the repo says $want"
  fail=1
fi

say
if [ "$fail" = 0 ]; then say "RESULT: clean"; else say "RESULT: $fail problem(s) - see above"; fi
exit $fail