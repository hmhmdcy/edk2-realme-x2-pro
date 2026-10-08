#!/usr/bin/env python3
"""Generate the Repo state block of HANDOVER-NEXT.md from git.

sync-docs-to-repo.sh calls this before it copies the documents, so the block
cannot drift.  The tip commit named in the block is the tip at generation time
(the health check only requires it to be an ancestor of the branch head, since
the commit that carries the block cannot name itself).
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
j = t.find("    fork remote:", i)
if i < 0 or j < 0:
    sys.exit("update-repo-state.py: cannot find the Repo state block in HANDOVER-NEXT.md")

lines = git("log", "--oneline", "-9").splitlines()
block = ""
for k, l in enumerate(lines):
    sha, _, subj = l.partition(" ")
    if k == 0:
        block += "    master = %s  %s\n" % (sha, subj)
    else:
        block += "             %s  %s\n" % (sha, subj)
ahead = git("rev-list", "--count", "origin/master..master")
block += "\n    %s commits ahead of upstream origin/master; all of them are on the fork.\n\n" % ahead

new = t[:i] + block + t[j:]
if new != t:
    open(P, "w", encoding="utf-8", newline="\n").write(new)
    print("  Repo state block regenerated: master = %s, %s commits ahead" % (lines[0].split()[0], ahead))
else:
    print("  Repo state block already current")