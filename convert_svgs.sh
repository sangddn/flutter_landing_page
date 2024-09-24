#!/bin/bash

# This script converts all SVG files in the input directory to SI files in the output directory.

# Input directory
input_dir="assets"

# Output directory
output_dir="assets/precompiled_svgs"

# Find all SVG files in the input directory (excluding the output directory)
find "$input_dir" -type f -name "*.svg" ! -path "$output_dir/*" | while read -r svg_file; do
  # Extract the base file name without the path and extension
  base_name=$(basename "$svg_file" .svg)
  
  # Check if the output .si file already exists
  if [ ! -f "$output_dir/$base_name.si" ]; then
    # Run the dart command if the output .si file does not exist
    dart run jovial_svg:svg_to_si "$svg_file" --out "$output_dir"
  else
    echo "Skipping $svg_file as it is already precompiled."
  fi
done
