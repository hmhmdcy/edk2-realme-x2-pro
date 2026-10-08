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
want=$(git -C "$RK" show HEAD:Platform/Realme/sm8150/HANDOVER-NEXT.md | sha256sum | cut -d' ' -f1)
got=$(sha256sum "$W/archive/HANDOVER-NEXT-full-2026-10-08.md" | cut -d' ' -f1)
say "   archive  $got"
say "   git HEAD $want"
if [ "$want" = "$got" ]; then say "   ok: verbatim"; else say "   WARN: differs from HEAD (HEAD may still be pre-split or already moved on)"; fi

say
say "== 4. Windows working copy vs repo mirror =="
for f in HANDOVER-NEXT.md README.md EUD.md BINARIES.md DOCS-INDEX.md DIAG-CAPTURE.md EVALUATION-AND-PLAN.md; do
  if [ -f "$W/$f" ] && [ -f "$P/$f" ]; then
    if ! diff -q "$W/$f" "$P/$f" >/dev/null; then say "   DRIFT: $f"; fail=1; fi
  else
    say "   missing on one side: $f"
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
if [ "$fail" = 0 ]; then say "RESULT: clean"; else say "RESULT: $fail problem(s) - see above"; fi
exit $fail