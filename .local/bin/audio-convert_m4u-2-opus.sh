#!/bin/bash
# Converts a given m4a file to opus

input_file="${1}"
backup_dir="${HOME}/Downloads/M4aToOpus-backup"
mkdir --parents "${backup_dir}"

# Guard
[ -f "${input_file}" ] || exit
[ "${input_file:(-4)}" == '.m4a' ] || exit

# Get new filename by removing the last 4 letters
this_name="$(basename "${input_file}")"
this_dir="$(dirname "${input_file}")"
output_file="${this_dir}/${this_name::-4}.opus"
backup_file="${backup_dir}/${this_name}"

# Do conversion
ffmpeg -i "${input_file}" -codec:a libopus -b:a 192 -vbr on  "${output_file}"

# Move old file to a backup
mv "${input_file}" "${backup_file}"
