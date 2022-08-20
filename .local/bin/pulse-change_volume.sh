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

# Get maximum volume, and the value of the loudest channel
_info="$(pactl --format=json list "${_interface}s" | \
    jq --raw-output 'map(select(.name == "'"${_name}"'")) | .[]')"
_maxval="$(echo "${_info}" | jq --raw-output '.base_volume.value')"
_curval="$(echo "${_info}" | jq --raw-output '.volume | [.[].value] | max')"

# Calculate target volume percentage to see if we need to do clipping
_stpval="$((_maxval * _stpvol / 100))"
_maxval="$((_maxval * _maxvol / 100))"
if [ "${_direction}" = '+' ] ; then
    _newval="$((_curval + _stpval))"
elif [ "${_direction}" = '-' ] ; then
    _newval="$((_curval - _stpval))"
fi

# Modulate volume
if [ "${_newval}" -lt '0' ] ; then
    # Lower clipping to 0; not needed
    pactl "set-${_interface}-volume" "${_name}" '0%'
elif [ "${_newval}" -ge "${_maxval}" ] ; then
    # Higher clipping to max
    pactl "set-${_interface}-volume" "${_name}" "${_maxvol}%"
else
    # No clipping
    pactl "set-${_interface}-volume" "${_name}" "${_direction}${_stpvol}%"
fi
