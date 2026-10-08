#!/usr/bin/env python3
"""Generate the whole Repo state block of HANDOVER-NEXT.md from git.

Invoked by sync-docs-to-repo.sh before it copies the documents, so the block can
never drift: the commit list, the "commits ahead" count and the fork remote are
all regenerated.  The tip commit it names is the tip at generation time and the
health check only requires it to be an ancestor of the branch head, because a
commit cannot name itself.
"""
import subprocess
import sys

W = "/mnt/e/RealmeX2Pro edk2"
RK = "/home/cy122/edk2-samurai/repo"
P = W + "/HANDOVER-NEXT.md"

def git(*a):
    r = subprocess.run(["git", "-C", RK] + list(a), capture_output=True, text=True, check=True)
    return r.stdout.strip()

t = open(P, encoding="utf-8").read()
i = t.find("    master = ")
k = t.find("\nDocumentation layout", i)
if i < 0 or k < 0:
    sys.exit("update-repo-state.py: cannot find the Repo state block in HANDOVER-NEXT.md")

lines = git("log", "--oneline", "-9").splitlines()
out = []
for n, l in enumerate(lines):
    sha, _, subj = l.partition(" ")
    out.append("%s%s  %s" % ("    master = " if n == 0 else "             ", sha, subj))
out.append("")
out.append("    %s commits ahead of upstream origin/master; all of them are on the fork."
           % git("rev-list", "--count", "origin/master..master"))
out.append("")
out.append("    fork remote: https://github.com/hmhmdcy/edk2-realme-x2-pro")
out.append("                 push with:  git push fork master")
out.append("                 (a plain git push goes to upstream edk2-porting/edk2-msm - never do that)")
out.append("")
block = "\n".join(out) + "\n"

new = t[:i] + block + t[k + 1:]
if new != t:
    open(P, "w", encoding="utf-8", newline="\n").write(new)
    print("  Repo state block regenerated: master = %s, %s commits ahead"
          % (lines[0].split()[0], git("rev-list", "--count", "origin/master..master")))
else:
    print("  Repo state block already current")