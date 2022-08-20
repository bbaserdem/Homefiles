#!/bin/bash
# Batch convert files in the current directory from mp3 to ogg

input_dir="${1}"
[ -d "${input_dir}" ] || echo "Directory ${input_dir} does not exist, or is not a directory."
output_dir="${input_dir}/ogv"
mkdir --parents "${output_dir}"

for input_file in "${input_dir}/"*.mkv; do
    # Guard
    [ -f "${input_file}" ] || break
    # Get full filename by removing the last 4 letters
    this_name="$(basename "${input_file::-4}")"
    output_file="${output_dir}/${this_name}.ogv"
    # Do conversionutput_file
    ffmpeg -i "${input_file}" -codec:v libtheora -q:v 10 -codec:a libopus -b:a 100k -vbr on "${output_file}"
done

for input_file in "${input_dir}/"*.webm; do
    # Guard
    [ -f "${input_file}" ] || break
    # Get full filename by removing the last 4 letters
    this_name="$(basename "${input_file::-5}")"
    output_file="${output_dir}/${this_name}.ogv"
    # Do conversionutput_file
    ffmpeg -i "${input_file}" -codec:v libtheora -q:v 10 -codec:a libopus -b:a 100k -vbr on "${output_file}"
done
