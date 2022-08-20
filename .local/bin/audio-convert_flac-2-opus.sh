#!/bin/bash
# Converts a given mp3 file to opus

input_file="${1}"
backup_dir="${HOME}/Downloads/FlacToOpus-backup"
mkdir --parents "${backup_dir}"

# Guard
[ -f "${input_file}" ] || exit
[ "${input_file:(-5)}" == '.flac' ] || exit

# Get new filename by removing the last 4 letters
this_name="$(basename "${input_file}")"
this_dir="$(dirname "${input_file}")"
output_file="${this_dir}/${this_name::-5}.opus"
backup_file="${backup_dir}/${this_name}"

# Do conversion
ffmpeg -i "${input_file}" -codec:a libopus -b:a 256k -vbr on  "${output_file}"

# Move old file to a backup
mv "${input_file}" "${backup_file}"
