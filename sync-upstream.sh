#!/bin/bash
# Sync with upstream and merge latest changes into max-custom-dev
# Usage: ./sync-upstream.sh

set -e

echo "=========================================="
echo "Syncing with upstream..."
echo "=========================================="

# Fetch from upstream
echo "[1/4] Fetching from upstream..."
git fetch upstream

# Update dev branch with upstream
echo "[2/4] Updating dev branch from upstream/dev..."
git checkout dev
git pull upstream dev

# Check for new commits
COMMITS_AHEAD=$(git log upstream/dev..dev --oneline | wc -l)
COMMITS_BEHIND=$(git log dev..upstream/dev --oneline | wc -l)

if [ $COMMITS_BEHIND -eq 0 ]; then
    echo "✓ Local dev is up to date with upstream/dev"
else
    echo "⚠ Local dev is $COMMITS_BEHIND commits behind upstream/dev"
fi

# Merge into max-custom-dev
echo ""
echo "[3/4] Switching to max-custom-dev..."
git checkout max-custom-dev

echo "[4/4] Attempting to merge dev into max-custom-dev..."
if git merge dev --no-edit; then
    echo ""
    echo "=========================================="
    echo "✓ Merge successful!"
    echo "=========================================="
    echo ""
    git log --oneline -5
else
    echo ""
    echo "=========================================="
    echo "⚠ Merge conflict detected"
    echo "=========================================="
    echo ""
    echo "Fix the conflicts and then run:"
    echo "  git add <files>"
    echo "  git commit"
    echo ""
    echo "Or abort the merge with:"
    echo "  git merge --abort"
    exit 1
fi
