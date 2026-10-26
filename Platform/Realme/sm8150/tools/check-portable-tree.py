#!/usr/bin/env python3
"""Reject machine-specific paths and credentials in the active device tree."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ACTIVE_ROOT = Path(__file__).resolve().parents[1]
SKIP_DIRS = {"archive", "reference", "sessions", ".git"}
SKIP_SUFFIXES = {
    ".aml",
    ".bin",
    ".dtb",
    ".efi",
    ".fd",
    ".gz",
    ".img",
    ".ko",
    ".o",
    ".raw",
    ".xz",
    ".zip",
}

CHECKS = (
    ("developer home path", re.compile(r"/home/(?!user(?:/|$))[A-Za-z0-9._-]+/")),
    ("Windows mount path", re.compile(r"/mnt/[A-Za-z]/")),
    ("Windows absolute path", re.compile(r"\b[A-Za-z]:[\\/]", re.IGNORECASE)),
    ("GitHub token", re.compile(r"\b(?:ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]+)\b")),
    (
        "private key",
        re.compile(r"-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----"),
    ),
)


def iter_active_files() -> list[Path]:
    files: list[Path] = []
    for path in ACTIVE_ROOT.rglob("*"):
        if not path.is_file() or path.is_symlink():
            continue
        relative = path.relative_to(ACTIVE_ROOT)
        if SKIP_DIRS.intersection(relative.parts):
            continue
        if path.suffix.lower() in SKIP_SUFFIXES:
            continue
        files.append(path)
    return files


def main() -> int:
    findings: list[str] = []
    for path in iter_active_files():
        try:
            data = path.read_bytes()
        except OSError as error:
            findings.append(f"{path.relative_to(ACTIVE_ROOT)}: unreadable: {error}")
            continue
        if b"\0" in data:
            continue
        text = data.decode("utf-8", errors="replace")
        for label, pattern in CHECKS:
            for match in pattern.finditer(text):
                line = text.count("\n", 0, match.start()) + 1
                findings.append(
                    f"{path.relative_to(ACTIVE_ROOT)}:{line}: {label}: {match.group(0)}"
                )

    if findings:
        print("Active-tree portability check failed:", file=sys.stderr)
        print("\n".join(findings), file=sys.stderr)
        return 1
    print("Active Realme X2 Pro tree contains no machine-specific paths or credentials.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
