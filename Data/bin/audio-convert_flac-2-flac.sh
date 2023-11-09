#!/bin/bash
# Re-encodes a flac file with max compression

input_file="${1}"
downl_dir="$(xdg-user-dir DOWNLOAD)"
[ -z "${downl_dir}" ] && downl_dir="${HOME}/Downloads"
backup_dir="${downl_dir}/FlacToFlac-backup"
mkdir --parents "${backup_dir}"

# Guard
[ -f "${input_file}" ] || exit
[ "${input_file:(-5)}" == '.flac' ] || exit

# Get new filename by removing the last 4 letters
this_name="$(basename "${input_file}")"
this_dir="$(dirname "${input_file}")"
output_file="${this_dir}/${this_name::-5}-compressed.flac"
backup_file="${backup_dir}/${this_name}"

# Do conversion, and if successful move old file to backup
ffmpeg -i "${input_file}" -codec:a flac -compression_level 12 "${output_file}" && mv "${input_file}" "${backup_file}"
