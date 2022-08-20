#!/bin/bash
# Batch convert files in the current (or given) directory from mp3 to ogg

if [ -n "${1}" ] ; then
    input_dir="${1}"
else
    input_dir="$(pwd)"
fi
[ -d "${input_dir}" ] || echo "Directory ${input_dir} does not exist, or is not a directory."

# Run scripts on all files under these directories
find "${input_dir}" -type f -name '*.mp3' -exec audio-convert_mp3-2-opus.sh {} \;
find "${input_dir}" -type f -name '*.m4a' -exec audio-convert_m4a-2-opus.sh {} \;
find "${input_dir}" -type f -name '*.flac' -exec audio-convert_flac-2-opus.sh {} \;
