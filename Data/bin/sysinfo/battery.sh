#!/bin/dash
# vim:ft=sh

# Kill all descendents on exit
trap 'exit' INT TERM
trap 'kill 0' EXIT

#################################
#  _       _   _                #
# | |_ ___| |_| |_ ___ ___ _ _  #
# | . | .'|  _|  _| -_|  _| | | #
# |___|__,|_| |_| |___|_| |_  | #
#                         |___| #
#################################
# Battery module;
#  * Defaults to battery id 0
#  * Does not have any functions

# On the PC; default to pwrstat interface
_host="$(uname -n)"
if [ "${_host}" = 'sbp-arch-work' ] || [ "${_host}" = 'sbp-gentoo-work' ] ; then
    instance='cyberpower'
fi
if [ -z "${SYSINFO_BAT_POLL}" ] ; then
    SYSINFO_BAT_POLL=60
fi
print_info () {
    feature=''
    # Default to 0
    if [ "${instance}" = 'default' ] ; then
        bid=0
    else
        bid="${instance}"
    fi
    # Get info on battery state
    if [ "${instance}" = 'cyberpower' ] ; then
        if [ ! -x '/usr/bin/upsc' ] ; then
            pre='󱔝 '
            txt=''
            suf=''
        elif upsc cyberpower >/dev/null 2>&1 ; then
            perc="$(upsc cyberpower battery.charge)"
            from="$(upsc cyberpower ups.status)"
            # Set the prefix to source
            case "$(echo "${from}" | awk '{print $1}')" in
                OL) pre='臘 ' ;;
                OB) pre=' ' ;;
                *) 
            esac
            # Clear suffix
            suf=''
            # Set the text
            txt="${perc} "
        else
            pre='ﳥ '
            txt=''
            feature='mute'
        fi
    else
        bat="$(acpi --battery    2>/dev/null | grep "Battery ${bid}" | head -n 1)"
        ada="$(acpi --ac-adapter 2>/dev/null | grep "Adapter ${bid}" | head -n 1)"
        # Return with error code early if there is no battery
        if [ -z "${bat}" ] ; then
            empty_output
            exit 1
        fi
        # Write important info to variables
        stat="$(echo "${bat}" | sed 's|Battery [0-9]: \([ ,A-Z,a-z]*\),.*|\1|')"
        perc="$(echo "${bat}" | sed 's|.*, \([0-9]\+\)%.*|\1|')"
        # Change the front icon to capacity; with sign if it's charging
        if [ "${stat}" = 'Charging' ] ; then
            if   [ "${perc}" -gt 99 ] ; then col="${base0B}" ; pre="󰂅 " ; class='good'
            elif [ "${perc}" -ge 90 ] ; then col="${base0B}" ; pre="󰂋 " ; class='good'
            elif [ "${perc}" -ge 80 ] ; then col="${base0B}" ; pre="󰂊 " ; class='good'
            elif [ "${perc}" -ge 70 ] ; then col="${base0B}" ; pre="󰢞 " ; class='good'
            elif [ "${perc}" -ge 60 ] ; then col="${base0A}" ; pre="󰂉 " ; class='ok'
            elif [ "${perc}" -ge 50 ] ; then col="${base0A}" ; pre="󰢝 " ; class='ok'
            elif [ "${perc}" -ge 40 ] ; then col="${base0A}" ; pre="󰂈 " ; class='ok'
            elif [ "${perc}" -ge 30 ] ; then col="${base09}" ; pre="󰂇 " ; class='warn'
            elif [ "${perc}" -ge 20 ] ; then col="${base08}" ; pre="󰂆 " ; class='low'
            else                             col="${base08}" ; pre="󰢜 " ; class='low'
            fi
        else
            if   [ "${perc}" -ge 80 ] ; then col="${base0B}" ; pre=" " ; class='good'
            elif [ "${perc}" -ge 60 ] ; then col="${base0A}" ; pre=" " ; class='ok'
            elif [ "${perc}" -ge 40 ] ; then col="${base09}" ; pre=" " ; class='warn'
            elif [ "${perc}" -ge 20 ] ; then col="${base08}" ; pre=" " ; class='low'
            else                             col="${base08}" ; pre=" " ; class='low'
            fi
        fi
        txt="${perc}"
        # Check if time info is available, and add it to text if it is
        if echo "${bat}" | grep -q -e 'until charged' -e 'remaining' ; then
            txt="${perc}, $(echo "${bat}" | awk '{print $5}' \
                | sed 's|\([0-9]\+:[0-9]\+\):[0-9]\+|\1|')"
        fi
        # Make the suffix into connected/not connected icon
        if [ "$(echo "${ada}" | awk '{print $3}')" = 'on-line' ] ; then
            suf=" "
        else
            suf=" 󰚦"
        fi
    fi
    # Print string
    formatted_output
}

print_loop () {
    print_info || exit
    # Also poll every 30 seconds
    pollling () {
        while : ; do
            sleep "${SYSINFO_BAT_POLL}"
            print_info || exit
        done
    }
    pollling &
    # Subscribe to acpi_listen
    /usr/bin/acpi_listen | while read -r line ; do
        if echo "${line}" | grep --quiet --ignore-case 'battery\|ac_adapter' ; then
            print_info || exit
        fi 
    done
}
