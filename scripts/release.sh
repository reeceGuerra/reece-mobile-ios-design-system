#!/usr/bin/env bash
set -euo pipefail

# Simple SemVer bump script for this repo.
# Usage: scripts/release.sh [major|minor|patch] [-n|--dry-run]
# - Reads latest annotated tag (vX.Y.Z). If none, starts at v0.0.0
# - Bumps the chosen segment and creates/pushes a new annotated tag.
# - Optionally updates CHANGELOG.md (if present) by inserting a new header.
#
# Requires: git

DRYRUN=0
if [[ "${2:-}" == "-n" || "${2:-}" == "--dry-run" ]]; then
  DRYRUN=1
fi

# Ensure clean tree
if ! git diff-index --quiet HEAD --; then
  echo "Working tree not clean. Commit or stash changes before releasing." >&2
  exit 1
fi

# Latest tag (annotated), default v0.0.0
LATEST=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
if [[ ! "$LATEST" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "Latest tag '$LATEST' is not semver (vX.Y.Z). Aborting." >&2
  exit 1
fi
MAJOR=${BASH_REMATCH[1]}
MINOR=${BASH_REMATCH[2]}
PATCH=${BASH_REMATCH[3]}

BUMP=${1:-minor}
case "$BUMP" in
  major) MAJOR=$((MAJOR+1)); MINOR=0; PATCH=0;;
  minor) MINOR=$((MINOR+1)); PATCH=0;;
  patch) PATCH=$((PATCH+1));;
  *) echo "Usage: $0 [major|minor|patch]"; exit 2;;
esac

NEW="v${MAJOR}.${MINOR}.${PATCH}"
DATE=$(date +%Y-%m-%d)

echo "Latest: $LATEST"
echo "New:    $NEW ($BUMP)"
echo "Date:   $DATE"

# Update CHANGELOG.md (prepend header if file exists)
if [[ -f CHANGELOG.md ]]; then
  TMP=$(mktemp)
  printf "## %s - %s\n\n- TBD\n\n" "$NEW" "$DATE" > "$TMP"
  cat CHANGELOG.md >> "$TMP"
  mv "$TMP" CHANGELOG.md
  if [[ $DRYRUN -eq 0 ]]; then
    git add CHANGELOG.md
    git commit -m "[DOCS]: Changelog for $NEW"
  else
    echo "[dry-run] would update CHANGELOG.md"
  fi
fi

# Create annotated tag
if [[ $DRYRUN -eq 0 ]]; then
  git tag -a "$NEW" -m "Release $NEW"
  git push origin "$NEW"
else
  echo "[dry-run] would tag $NEW and push"
fi

echo "Done."
