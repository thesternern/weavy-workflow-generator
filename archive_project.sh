#!/bin/bash
# Archive current workflow JSONs into a labeled project folder.
# Usage: ./archive_project.sh "Project Name" ["Optional description"]
# Example: ./archive_project.sh "Oakley Meta Vanguard" "Athlete desert running campaign - iterative I2V + QA pipeline"

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ARCHIVE_DIR="$SCRIPT_DIR/archive"

if [ -z "$1" ]; then
  echo "Usage: ./archive_project.sh \"Project Name\" [\"Description\"]"
  echo ""
  echo "Current workflow files:"
  ls -1 "$SCRIPT_DIR"/workflow*.json 2>/dev/null || echo "  (none)"
  echo ""
  echo "Existing archives:"
  ls -1d "$ARCHIVE_DIR"/*/ 2>/dev/null | while read -r d; do
    basename "$d"
  done || echo "  (none)"
  exit 1
fi

PROJECT_NAME="$1"
DESCRIPTION="${2:-}"
DATE=$(date +%Y-%m-%d)

# Slugify the project name for the folder
SLUG=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
FOLDER_NAME="${DATE}_${SLUG}"
DEST="$ARCHIVE_DIR/$FOLDER_NAME"

# Check for existing archive with same name
if [ -d "$DEST" ]; then
  echo "Archive already exists: $DEST"
  echo "Remove it first or use a different name."
  exit 1
fi

# Find workflow JSONs
JSON_FILES=("$SCRIPT_DIR"/workflow*.json)
if [ ! -e "${JSON_FILES[0]}" ]; then
  echo "No workflow*.json files found to archive."
  exit 1
fi

# Create archive folder and move files
mkdir -p "$DEST"

COUNT=0
for f in "${JSON_FILES[@]}"; do
  cp "$f" "$DEST/"
  COUNT=$((COUNT + 1))
done

# Build manifest
MANIFEST="$DEST/MANIFEST.md"
cat > "$MANIFEST" <<EOF
# ${PROJECT_NAME}

- **Archived:** ${DATE}
- **Files:** ${COUNT}
EOF

if [ -n "$DESCRIPTION" ]; then
  echo "- **Description:** ${DESCRIPTION}" >> "$MANIFEST"
fi

echo "" >> "$MANIFEST"
echo "## Files" >> "$MANIFEST"
echo "" >> "$MANIFEST"

for f in "${JSON_FILES[@]}"; do
  FNAME=$(basename "$f")
  SIZE=$(wc -c < "$f" | tr -d ' ')
  # Count nodes and edges from the JSON
  NODES=$(python3 -c "import json; d=json.load(open('$f')); print(len(d.get('nodes',[])))" 2>/dev/null || echo "?")
  EDGES=$(python3 -c "import json; d=json.load(open('$f')); print(len(d.get('edges',[])))" 2>/dev/null || echo "?")
  echo "- \`${FNAME}\` — ${NODES} nodes, ${EDGES} edges (${SIZE} bytes)" >> "$MANIFEST"
done

# Remove originals from workspace root
for f in "${JSON_FILES[@]}"; do
  rm "$f"
done

echo ""
echo "Archived ${COUNT} files to: archive/${FOLDER_NAME}/"
echo ""
cat "$MANIFEST"
echo ""
echo "Workspace is clean. Ready for a new project."
