#!/bin/bash

# Current directory and conversion folder
DIR="$(cd "$(dirname "$0")" && pwd)"
CONVERTEDFOLDER="converted_to_mp4"
filesfound=false

echo ""
echo "avi converter using ffmpeg."
echo ""

echo "Scanning: $DIR"

# Check for .avi files
for file in "$DIR"/*.avi; do
  if [ -f "$file" ]; then
    filesfound=true
    echo "$(basename "$file")"
  fi
done

echo ""

# Exit if no files found
if ! $filesfound; then
  echo "No convertable files found"
  exit 0
fi

echo "Convertable files found"
echo ""

# Prompt user for conversion
echo "Would you like to convert these files? (Y/N)"
read input

input=$(echo "$input" | tr '[:lower:]' '[:upper:]')

if [ "$input" = "Y" ]; then
  mkdir -p "$CONVERTEDFOLDER"
  echo "'$CONVERTEDFOLDER' created."
  echo "Converting"

  # Convert each .avi file
  for file in "$DIR"/*.avi; do
    if [ -f "$file" ]; then
      output_file="$CONVERTEDFOLDER/$(basename "$file" .avi).mp4"
      ffmpeg -i "$file" -c:v libx264 -crf 18 -preset slow -c:a aac -b:a 192k "$output_file"
    fi
  done
  
  echo "Successfully converted from avi to mp4!"

elif [ "$input" = "N" ]; then
  echo "Closing...."
  exit 0

else
  echo "Invalid input. Y/N Only"
  exit 0
fi