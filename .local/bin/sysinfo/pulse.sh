#!/bin/dash
# vim:ft=sh

# Kill all descendents on exit
trap 'exit' INT TERM
trap 'kill 0' EXIT

# Buffer duration to stagger; in miliseconds
_bufdur=200

#########################################
#          _                   _ _      #
#  ___ _ _| |___ ___ ___ _ _ _| |_|___  #
# | . | | | |_ -| -_| .'| | | . | | . | #
# |  _|___|_|___|___|__,|___|___|_|___| #
# |_|                                   #
#########################################
# Pipewire-pulseaudio module;
#  * Only needs pactl (libpulse)
#  * Needs a instance of either 'sink' or 'source'
if [ -z "${instance}" ] || [ "${instance}" = 'default' ] ; then
    instance='sink'
elif [ "${instance}" != 'source' ] && [ "${instance}" != 'sink' ] ; then
    exit 2
fi

click_left () { # Left click action
    # Toggle mute
    /usr/bin/pactl "set-${instance}-mute" \
        "@DEFAULT_$(echo ${instance} | awk '{print toupper($0)}')@" toggle
}

# Middle mouse action
click_middle () { 
    if [ "${instance}" = 'source' ] ; then
        pulse-change_default.sh -s 
    elif [ "${instance}" = 'sink' ] ; then
        pulse-change_default.sh 
    fi
}

# Right mouse action
click_right () {
    ( flock --nonblock 7 || exit 7
        if [ -x '/usr/bin/pavucontrol' ] ; then
            /usr/bin/pavucontrol
        fi
    ) 7>"${SYSINFO_FLOCK_DIR}/${name}_${IDENTIFIER}_right" >/dev/null 2>&1 &
}

# Scroll up
scroll_up () {
    if [ "${instance}" = 'source' ] ; then
        pulse-change_volume.sh -s -p 1
    elif [ "${instance}" = 'sink' ] ; then
        pulse-change_volume.sh -p 1
    fi
}

# Scroll down
scroll_down () {
    if [ "${instance}" = 'source' ] ; then
        pulse-change_volume.sh -s -r -p 1
    elif [ "${instance}" = 'sink' ] ; then
        pulse-change_volume.sh -r -p 1
    fi
}

print_info () {
    feature=''
    suf=''
    _name="$(pactl --format=json info | jq --raw-output ".default_${instance}_name")"
    _info="$(pactl --format=json list "${instance}s" | \
        jq --raw-output 'map(select(.name == "'"${_name}"'")) | .[]')"
    # Mute and volume info
    _mute="$(echo "${_info}" | jq --raw-output '.mute')"
    _volm="$(echo "${_info}" | jq --raw-output \
        '.volume | [.[].value_percent] | map(.[:-1] | tonumber?) | add / length | ceil')"
    # Get active port, and it's type
    _port="$(echo "${_info}" | jq --raw-output '.active_port')"
    _ptyp="$(echo "${_info}" | jq --raw-output '.ports | map(select(.name == "'"${_port}"'")) | .[].type')"
    # Get icon name
    _icon="$(echo "${_info}" | jq --raw-output '.properties."device.icon_name"')"
    # Check if it's a bluetooth sink, adjust suffix
    echo "${_name}" | grep -q 'bluez' && suf=' '
    if [ "${instance}" = 'sink' ] ; then 
        # Determine icon for the sink, based on device.icon_name
        case "${_name}" in
            *"HDMI"*)                                                 pre="﴿ "                   ;;
            *"DualShock"*)                                            pre=" "                   ;;
            *)
                case "${_icon}" in
                    *usb*)                                            pre="禍 "                 ;;
                    *hdmi*)                                           pre="﴿ "                  ;;
                    *headset*)            [ "${_mute}" = 'false' ] && pre=" "  || pre=" "     ;;
                    *a2dp*)               [ "${_mute}" = 'false' ] && pre="﫽 " || pre="﫾 "    ;;
                    *hifi*|*stereo*)                                  pre="﫛 "                 ;;
                    *headphone*|*lineout*)[ "${_mute}" = 'false' ] && pre=" "  || pre="ﳌ "     ;;
                    *speaker*)            [ "${_mute}" = 'false' ] && pre="蓼 " || pre="遼 "    ;;
                    *network*)                                        pre="爵 "                 ;;
                    *)                    [ "${_mute}" = 'false' ] && pre="墳 " || pre="ﱝ "     ;;
                esac
                ;;
        esac
        # # Determine icon, based on active port type
        # case "${_ptyp}" in
        #     HDMI*)       if [ "${_mute}" = 'false' ] && pre="﴿ " || pre="﴿ " ;;
        #     Line*)      if [ "${_mute}" = 'false' ] && pre=" " || pre=" " ;;
        #     Headphones) if [ "${_mute}" = 'false' ] && pre=" " || pre="ﳌ " ;;
        #     *USB*)      if [ "${_mute}" = 'false' ] && pre=" " || pre=" " ;;
        #     Speaker)    if [ "${_mute}" = 'false' ] && pre="蓼 " || pre="遼 " ;;
        #     *)          if [ "${_mute}" = 'false' ] && pre="墳 " || pre="婢 " ;;
        # esac
    elif [ "${instance}" = 'source' ] ; then
        # Determine icon for the sink
        case "${_icon}" in
            audio-card-pci) [ "${_mute}" = 'no' ] && pre=" "  || pre=" " ;;
            camera-web-usb)                          pre="犯 "             ;;
            *)              [ "${_mute}" = 'no' ] && pre=" "  || pre=" " ;;
        esac
        # Check if it's a bluetooth source
        if echo "${_icon}" | grep -q 'bluez' ; then
            suf=' '
        else
            suf=''
        fi
    else
        empty_output
        exit 1
    fi
    txt="${_volm}"
    if [ "${_mute}" = 'true' ] ; then
        feature='mute'
    fi
    # Print string
    formatted_output
}

print_loop () {
    # Wrapper on listener that will do staggered prints
    # Subscribe to listener; and capture all stdin and stderr
    # First echo'd line will be the PID; so we can avoid orphans
    (pactl subscribe 2>&1 & echo "${!}" && wait) | (
        # Trap to kill the listener if parser loop is done
        trap 'kill "${_thispid}"; trap - EXIT' EXIT
        read -r _thispid
        # Do first line of printing, and record the time.
        print_info && _last="$(($(date '+%s%3N') - _bufdur))" || exit
        # Loop until listener breaks
        while ps -o pid= -p "${_thispid}" >/dev/null 2>&1 ; do
            # Wait until pactl submits relevant event
            grep --max-count=1 --quiet --line-buffered  \
                --regexp "Event 'change' on server "    \
                --regexp "Event 'change' on sink "
            _curr="$(date '+%s%3N')"
            # Print only if the time between last and now is beyond buffer
            if [ "$((_curr - _last))" -ge "${_bufdur}" ] ; then
                print_info && _last="${_curr}" || exit
                # Schedule another line of printing to refresh after buffer
                ( sleep "${_bufdur}e-3s" ; print_info ) &
            fi
        done
    )
}
