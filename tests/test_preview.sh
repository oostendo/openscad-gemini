#!/bin/bash

# Configuration
SCAD_FILE="tests/simple_cube.scad"
OUTPUT_FILE="tests/preview_test.png"

# Ensure clean state
rm -f "$OUTPUT_FILE"

echo "Running OpenSCAD preview generation test..."

# Run OpenSCAD command (mimicking the project's workflow)
openscad -o "$OUTPUT_FILE" \
  --imgsize=512,512 \
  --camera=0,0,0,60,0,25,500 \
  --projection=o \
  "$SCAD_FILE"

EXIT_CODE=$?

# Check Exit Code
if [ $EXIT_CODE -ne 0 ]; then
    echo "FAIL: OpenSCAD command failed with exit code $EXIT_CODE"
    exit 1
fi

# Check if file exists
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "FAIL: Output file was not created."
    exit 1
fi

# Check if file is empty
FILE_SIZE=$(stat -c%s "$OUTPUT_FILE" 2>/dev/null || stat -f%z "$OUTPUT_FILE")
if [ "$FILE_SIZE" -eq 0 ]; then
    echo "FAIL: Output file is empty (0 bytes)."
    rm "$OUTPUT_FILE"
    exit 1
fi

echo "SUCCESS: Preview image generated ($FILE_SIZE bytes)."
rm "$OUTPUT_FILE"
exit 0
