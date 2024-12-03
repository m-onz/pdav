#!/bin/bash

SCRIPT_NAME="${0##*/}"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log_message "Starting audio processing..."

# Step 1: Rename .wav files
log_message "Renaming .wav files..."
find . -maxdepth 1 -type f -name "*.wav" | sort | awk '{printf "mv \"%s\" \"file_%03d.wav\"\n", $0, NR}' | bash
if [ $? -ne 0 ]; then
    log_message "Error renaming files. Exiting."
    exit 1
fi

#./split_on_silence.sh
#echo "test"
#./split_on_chunks.sh
