#!/bin/bash

# Check if there are any .wav files in the directory
if [ "$(ls *.wav 2>/dev/null)" = "" ]; then
    echo "No .wav files found in the current directory."
    exit 1
fi

# Set the silence threshold (in seconds)
SILENCE_THRESHOLD=0.1

# Loop through all .wav files in the current directory
for file in *.wav; do
    # Skip the script itself if it's mistakenly renamed to .wav
    if [ "$file" = "${0##*/}" ]; then
        continue
    fi
    
    # Get the base name of the file (without extension)
    basename="${file%.wav}"
    
    # Get the duration of the file
    duration=$(soxi -D "$file")
    
    # Check if the duration is below the threshold
    if (( $(echo "$duration < $SILENCE_THRESHOLD" | bc -l) )); then
        echo "Deleting silent file: $file"
        rm "$file"
    else
        echo "Keeping non-silent file: $file"
    fi
done

echo "Silent file detection and deletion completed."
