#!/bin/bash

# Add some debugging
set -e  # Exit on any error

# === Config ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_DIR="${SCRIPT_DIR}/defects4j_projects"  # Use absolute path
OUTPUT_DIR="${SCRIPT_DIR}/test_results"       # Use absolute path

echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"

# Create the output folder if it doesn't exist
mkdir -p "$OUTPUT_DIR"
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "Failed to create output directory: $OUTPUT_DIR"
  exit 1
fi

# === Loop through each project/version directory ===
for project_path in "$INPUT_DIR"/*; do
  if [ -d "$project_path" ]; then
    project_name=$(basename "$project_path")
    output_file="${OUTPUT_DIR}/${project_name}_output.txt"
    
    echo "🧪 Running compile and test for $project_name"

    # Change to the project directory and run defects4j commands
    pushd "$project_path" > /dev/null || { echo "Failed to enter $project_path"; continue; }
    
    # Run the commands and collect output
    {
      echo "== COMPILING =="
      defects4j compile
      
      echo -e "\n== RUNNING TESTS =="
      defects4j test
    } > "$output_file" 2>&1
    
    # Return to the original directory
    popd > /dev/null
    
    # Verify the output file was created
    if [ -f "$output_file" ]; then
      echo "✅ Saved output to $output_file"
    else
      echo "❌ Failed to save output for $project_name"
    fi
  fi
done