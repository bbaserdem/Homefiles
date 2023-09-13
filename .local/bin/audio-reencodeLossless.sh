#!/bin/bash
# Batch convert files in the current (or given) directory from mp3 to ogg

if [ -n "${1}" ] ; then
    input_dir="${1}"
else
    input_dir="$(pwd)"
fi
[ -d "${input_dir}" ] || echo "Directory ${input_dir} does not exist, or is not a directory."

# Run scripts on all files under these directories
find "${input_dir}" -type f -name '*.flac' -exec audio-convert_flac-2-flac.sh {} \;
find "${input_dir}" -type f -name '*.aiff' -exec audio-convert_aiff-2-flac.sh {} \;
