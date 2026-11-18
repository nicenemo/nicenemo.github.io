#!/usr/bin/env bash
# Dependency security checks for the Hugo site. The site has no package manager and loads nothing from third parties,
# so the checks are: no vendored libraries in the source tree, no external resource in the built pages, and
# osv-scanner for any lockfile that is ever added. Usage: scripts/check-dependencies.sh [--osv]
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0

# 1. Vendored third-party libraries are not allowed (they are what Dependabot reports on and nothing updates them).
vendored="$(find . \( -path ./.git -o -path ./public -o -path ./resources \) -prune -o \
    \( -name '*.min.js' -o -name '*.min.css' -o -name node_modules -o -name bower_components -o -path '*/assets/plugins' \) \
    -print)"
if [ -n "$vendored" ]; then
    echo "vendored third-party files found:" >&2; echo "$vendored" >&2; fail=1
fi

# 2. Built pages must not load anything from another origin (script, stylesheet, font, image, frame, media).
out="$(mktemp -d)"; trap 'rm -rf "$out"' EXIT
hugo --gc --minify --destination "$out" >/dev/null 2>&1 || { echo "hugo build failed" >&2; exit 1; }
external="$(grep -rEoh --include='*.html' \
    '<(script|img|iframe|embed|source|video|audio)[^>]*[ ](src|srcset)=["'"'"']?https?://[^ >"'"'"']+|<link[^>]*rel=["'"'"']?(stylesheet|preload|modulepreload)[^>]*href=["'"'"']?https?://[^ >"'"'"']+' \
    "$out" | sort -u || true)"
if [ -n "$external" ]; then
    echo "external resources in the built site (copy them into static/ instead of linking):" >&2
    echo "$external" >&2; fail=1
fi

# 3. Known vulnerabilities in lockfiles (none today). Needs the network, so only on request.
if [ "${1:-}" = "--osv" ]; then
    rc=0; osv-scanner scan source --recursive . || rc=$?
    # 128 means there is no package source to scan, which is the normal state of this repository.
    if [ "$rc" -ne 0 ] && [ "$rc" -ne 128 ]; then fail=1; fi
fi

exit "$fail"
