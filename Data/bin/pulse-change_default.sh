#!/bin/dash
# vim:ft=sh
# Script to change pulseaudio sink

_reverse='no'
_interf='sink'
_stream='sink-input'
while getopts "r:s" option; do
    case "${option}" in
        r)  _reverse='yes'
            ;;
        s)  _interf='source'
            _stream='source-output'
            ;;
        ?)  exit 1
            ;;
    esac
done

# Get pipewire-pulse info
_pwinf="$(pactl --format=json info)"

# Get list of available interfaces and streams
_ilist="$(pactl --format=json list "${_interf}s")"
_slist="$(pactl --format=json list "${_stream}s")"

# Get number of interfaces and streams, and quit if there is only one interface
_inum="$(echo "${_ilist}" | jq 'length')"
if [ "${_inum}" = 1 ] ; then
    exit
fi
_snum="$(echo "${_slist}" | jq 'length')"

# Get the IDs and names of the interfaces
_iind="$(echo "${_ilist}" | jq --raw-output '.[].index')"
_inam="$(echo "${_ilist}" | jq --raw-output '.[].name')"

# Get the current default interface
_cinam="$(echo "${_pwinf}" | jq --raw-output ".default_${_interf}_name")"
_ciind="$(echo "${_ilist}" | jq --raw-output 'map(select(.name == "'"${_cinam}"'")) | .[].index')"
_cinum="$(echo "${_ilist}" | jq --raw-output "map(objects | .index) | index(${_ciind})")"

# Calculate the next sink information
if [ "${_reverse}" = 'no' ] ; then
    _ninum="$(( ( _cinum + 1 ) % _inum ))"
elif [ "${_reverse}" = 'yes' ]; then
    _ninum="$(( ( _cinum - 1 ) % _inum ))"
fi
_niind="$(echo "${_ilist}" | jq --raw-output ".[${_ninum}].index")"
_ninam="$(echo "${_ilist}" | jq --raw-output ".[${_ninum}].name")"

# Switch default sink to this one 
pactl "set-default-${_interf}" "${_ninam}"

# Switch all streams here
_i=0
while [ "${_i}" -lt "${_snum}" ] ; do
    _csind="$(echo "${_slist}" | jq --raw-output ".[${_i}].index")"
    _csfla="$(echo "${_slist}" | jq --raw-output ".[${_i}].flags")"
    # Advance the index
    _i="$(( _i + 1 ))"
    # Don't move if the DONT_MOVE flag is on
    if echo "${_csfla}" | grep --quiet 'DONT_MOVE' ; then
        continue
    fi
    # Move the sink
    pactl "move-${_stream}" "${_csind}" "${_ninam}"
done
