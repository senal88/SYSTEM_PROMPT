#!/bin/bash

# Check if there are any new changelog files in the staged changes
# This script ensures that each commit includes at least one new changelog file

# Get list of staged files
staged_files=$(git diff --cached --name-only)

# Check if any staged files are in the changelogs directory
changelog_files=$(echo "$staged_files" | grep "^changelogs/" || true)

if [ -z "$changelog_files" ]; then
    echo "❌ Error: No changelog files found in staged changes."
    echo "   Please add at least one new changelog file to your commit."
    echo "   Changelog files should be placed in the 'changelogs/' directory."
    echo ""
    echo "   Example:"
    echo "   git add changelogs/$(date +%Y-%m-%d-%H%M%S).yml"
    exit 1
fi

# Count the number of changelog files
changelog_count=$(echo "$changelog_files" | wc -l | tr -d ' ')

echo "✅ Found $changelog_count changelog file(s) in staged changes:"
echo "$changelog_files" | sed 's/^/   /'

exit 0
