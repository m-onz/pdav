#!/bin/bash

# Check if there are any .wav files in the directory
if [ "$(ls *.wav 2>/dev/null)" = "" ]; then
    echo "No .wav files found in the current directory."
    exit 1
fi

# Initialize a counter for total chunks
total_chunks=0

# Loop through all .wav files in the current directory
for file in *.wav; do
    # Skip the script itself if it's mistakenly renamed to .wav
    if [ "$file" = "${0##*/}" ]; then
        continue
    fi
    
    # Get the base name of the file (without extension)
    basename="${file%.wav}"
    
    # Initialize chunk counter for this file
    chunk_counter=1
    
    # Run the Sox command
    if sox "$file" "${basename}_chunk_%03d.wav" trim 0 1 : newfile : restart fade q 0.05 0.95 0.05; then
        echo "Successfully processed $file into chunks"
        
        # Count the number of chunks created
        num_chunks=$(ls "${basename}_chunk_"*.wav | wc -l)
        total_chunks=$((total_chunks + num_chunks))
        
        echo "Created $num_chunks chunks from $file"
    else
        echo "Error processing $file"
    fi
done

echo "Processing completed."
echo "Total chunks created: $total_chunks"
