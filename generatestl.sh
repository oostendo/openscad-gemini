#!/bin/bash

# Default values
OUTPUT_FILE=""

# Usage function
usage() {
    echo "Usage: $0 [options] <input_scad_file>"
    echo "Options:"
    echo "  -o <output_file>  Specify output filename (default: stl/<input_basename>.stl)"
    echo "  -h                Show this help message"
    exit 1
}

# Parse options
while getopts ":o:h" opt; do
  case ${opt} in
    o) OUTPUT_FILE=$OPTARG ;;
    h) usage ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
  esac
done
shift $((OPTIND -1))

# Check for input file
INPUT_FILE=$1
if [ -z "$INPUT_FILE" ]; then
    echo "Error: Input SCAD file is required."
    usage
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# Determine output file if not set
if [ -z "$OUTPUT_FILE" ]; then
    BASENAME=$(basename "$INPUT_FILE" .scad)
    # Default to 'stl' directory in project root
    OUTPUT_FILE="stl/${BASENAME}.stl"
fi

# Ensure output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "Generating STL for $INPUT_FILE..."
echo "Output: $OUTPUT_FILE"

# Execute OpenSCAD for STL export (headless)
# Note: xvfb-run is generally not required for STL export, but included for consistency/safety if dependencies trigger GUI code
if command -v xvfb-run &> /dev/null; then
    RUN_CMD="xvfb-run --auto-servernum --server-num=1 openscad"
else
    RUN_CMD="openscad"
fi

$RUN_CMD -o "$OUTPUT_FILE" "$INPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Success! STL generated."
else
    echo "Failed to generate STL."
    exit 1
fi
