#!/bin/dash
# vim:ft=sh
# Script to change pulseaudio default sink volume
#   Default behavior is to increase volume of the default sink
#   -r to decrease volume
#   -s to modulate source
#   -c to specify the channel name (default is the default channel)
#   -p for percentage to modulate (default 5)
#   -m for setting maximum percentage (default 100)
_direction='+'
_interface='sink'
_stpvol='5'
_name=''
_maxvol='100'
while getopts ":rsc:p:m:" option; do
    case "${option}" in
        r)  _direction='-'      ;;
        s)  _interface='source' ;;
        c)  _name="${OPTARG}"   ;;
        p)  _stpvol="${OPTARG}" ;;
        m)  _maxvol="${OPTARG}" ;;
        ?)  exit 1              ;;
    esac
done

# Get default interface name, if we are not given the name
if [ -z "${_name}" ] ; then
    _name="$(pactl --format=json info | jq --raw-output ".default_${_interface}_name")"
fi

# Do change
pactl "set-${_interface}-volume" "${_name}" "${_direction}${_stpvol}%"

# Check if we need to clip
if [ "${_direction}" = '+' ] ; then
    _info="$(pactl --format=json list "${_interface}s" | \
        jq --raw-output 'map(select(.name == "'"${_name}"'")) | .[]')"
    _maxval="$(echo "${_info}" | jq --raw-output '.base_volume.value')"
    _curval="$(echo "${_info}" | jq --raw-output '.volume | [.[].value] | max')"
    if [ "${_curval}" -ge "${_maxval}" ] ; then
        pactl "set-${_interface}-volume" "${_name}" '100%'
    fi
fi
