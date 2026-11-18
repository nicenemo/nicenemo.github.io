#!/usr/bin/env bash
# Point git at the tracked hooks in .githooks/ (hooks are not cloned automatically).
set -euo pipefail
cd "$(dirname "$0")"
git config core.hooksPath .githooks
echo "git hooks enabled: .githooks/pre-commit (gitleaks, yamllint, actionlint, markdownlint, hugo build), .githooks/pre-push (trufflehog)"
