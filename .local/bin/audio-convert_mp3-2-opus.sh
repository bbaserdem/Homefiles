#!/bin/bash
# Converts a given mp3 file to opus

input_file="${1}"
backup_dir="${HOME}/Downloads/Mp3ToOpus-backup"
mkdir --parents "${backup_dir}"

# Guard
[ -f "${input_file}" ] || exit
[ "${input_file:(-4)}" == '.mp3' ] || exit

# Get new filename by removing the last 4 letters
this_name="$(basename "${input_file}")"
this_dir="$(dirname "${input_file}")"
output_file="${this_dir}/${this_name::-4}.opus"
backup_file="${backup_dir}/${this_name}"

# Get the bitrate of the file
this_rate="$(exiftool -AudioBitrate "${input_file}" | \
    sed 's|[^0-9]*\([0-9]\+\) kbps.*|\1|')"
# Choose output bitrate
if      [ "${this_rate}" -ge 300 ] ; then
    output_rate='192k'
elif    [ "${this_rate}" -ge 200 ] ; then
    output_rate='128k'
else
    output_rate='96k'
fi

# Do conversion
ffmpeg -i "${input_file}" -codec:a libopus -b:a "${output_rate}" -vbr on  "${output_file}"

# Move old file to a backup
mv "${input_file}" "${backup_file}"
