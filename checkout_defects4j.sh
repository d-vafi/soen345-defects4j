#!/bin/bash

# === Configuration ===
PROJECTS=("Lang" "Gson" "Mockito")           # Defects4J projects
VERSIONS=("1b" "2b" "3b" "4b")                  # Buggy versions (e.g., 1b = bug 1)
OUTPUT_DIR="./defects4j_projects"          # Where to place checked-out projects

# === Setup ===
mkdir -p "$OUTPUT_DIR"

# === Loop through projects and versions ===
for project in "${PROJECTS[@]}"; do
  for version in "${VERSIONS[@]}"; do
    dir="${OUTPUT_DIR}/${project}_${version}"
    echo "Checking out $project-$version into $dir"
    
    # Use defects4j to checkout the buggy version
    defects4j checkout -p "$project" -v "$version" -w "$dir"

    if [ $? -eq 0 ]; then
      echo "✅ Checked out $project-$version"
    else
      echo "❌ Failed to checkout $project-$version"
    fi
  done
done