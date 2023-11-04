#!/bin/bash
# Batch convert files in the current (or given) directory from mp3 to ogg

if [ -n "${1}" ] ; then
    input_dir="${1}"
else
    input_dir="$(pwd)"
fi
[ -d "${input_dir}" ] || echo "Directory ${input_dir} does not exist, or is not a directory."

# Run scripts on all files under these directories
find "${input_dir}" -type f -name '*.flac' | parallel audio-convert_flac-2-flac.sh '{}'
find "${input_dir}" -type f -name '*.aiff' | parallel audio-convert_aiff-2-flac.sh '{}'
find "${input_dir}" -type f -name '*.wav'  | parallel audio-convert_wav-2-flac.sh  '{}'

# Alert that conversion is done
notify-send "Lossless re-encoding is done!" -i dialog-info
