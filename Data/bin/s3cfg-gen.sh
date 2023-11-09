#!/bin/sh

# The output script file
_file="${HOME}/.s3cfg"

# If the script exists, delete it
if [ -e "${_file}" ] ; then
    rm "${_file}"
fi

# Echo appropriate lines to the script
echo "[default]
access_key = $(pass AWS | awk '/access-key-id/ {print $2}')
secret_key = $(pass AWS | awk '/secret-access-key/ {print $2}')" > ~/.s3cfg

# Make secret
chmod u=r,g=,o= "${_file}"
