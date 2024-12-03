#!/bin/bash

# Check if there are any .wav files in the directory
if [ "$(ls *.wav 2>/dev/null)" = "" ]; then
    echo "No .wav files found in the current directory."
    exit 1
fi

# Loop through all .wav files in the current directory
for file in *.wav; do
    # Skip the script itself if it's mistakenly renamed to .wav
    if [ "$file" = "${0##*/}" ]; then
        continue
    fi
    
    # Get the base name of the file (without extension)
    basename="${file%.wav}"
    
    # Generate a unique output filename
    output_file="${basename}_processed.wav"
    
    # Run the Sox command
    if sox "$file" "$output_file" silence 1 0.1 1% -1 0.1 1% : newfile : restart; then
        echo "Successfully processed $file -> $output_file"
    else
        echo "Error processing $file"
    fi
done

echo "Processing completed."
