#!/bin/bash

# Default values
CAMERA="0,0,0,60,0,25,500"
IMGSIZE="1024,768"
OUTPUT_FILE=""

# Usage function
usage() {
    echo "Usage: $0 [options] <input_scad_file>"
    echo "Options:"
    echo "  -o <output_file>  Specify output filename (default: <input_dir>/preview/<input_basename>.png)"
    echo "  -c <camera>       Specify camera settings (default: $CAMERA)"
    echo "  -s <size>         Specify image size (default: $IMGSIZE)"
    echo "  -h                Show this help message"
    exit 1
}

# Parse options
while getopts ":o:c:s:h" opt; do
  case ${opt} in
    o) OUTPUT_FILE=$OPTARG ;;
    c) CAMERA=$OPTARG ;;
    s) IMGSIZE=$OPTARG ;;
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
    DIRNAME=$(dirname "$INPUT_FILE")
    # Default to a 'preview' subdirectory if it exists, otherwise same dir
    if [ -d "$DIRNAME/preview" ]; then
        OUTPUT_FILE="$DIRNAME/preview/${BASENAME}.png"
    else
        OUTPUT_FILE="$DIRNAME/${BASENAME}.png"
    fi
fi

# Ensure output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "Generating preview for $INPUT_FILE..."
echo "Output: $OUTPUT_FILE"
echo "Camera: $CAMERA"
echo "Size:   $IMGSIZE"

# Execute OpenSCAD via xvfb-run
xvfb-run --auto-servernum --server-num=1 openscad \
    -o "$OUTPUT_FILE" \
    --imgsize="$IMGSIZE" \
    --camera="$CAMERA" \
    --projection=o \
    "$INPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Success!"
else
    echo "Failed to generate preview."
    exit 1
fi
