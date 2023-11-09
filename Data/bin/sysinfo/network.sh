#!/bin/dash
# vim:ft=sh

# Kill all descendents on exit
trap 'exit' INT TERM
trap 'kill 0' EXIT

# Buffer duration to stagger; in milliseconds
_bufdur=200

###################################
#          _                 _    #
#  ___ ___| |_ _ _ _ ___ ___| |_  #
# |   | -_|  _| | | | . |  _| '_| #
# |_|_|___|_| |_____|___|_| |_,_| #
###################################
# Network module;
#  * Either fixes an interface using instance; or picks it using ip route
#  * Expects the interfaces to be labelled ethernet or wifi
print_info () {
    pre=''
    # Get the interface
    if [ "${instance}" = 'default' ] ; then
        intfc="$(ip route | awk '/^default via/ {print $5}')"
        # Exit if there isn't anything
        if [ -z "${intfc}" ] ; then
            empty_output
            exit
        fi
    else
        intfc="${instance}"
        int_list="$(ip addr | awk -F ': ' '/^[0-9]+/ {print $2}')"
        # Check if valid interface
        if echo "${int_list}" | grep --quiet --invert-match "${intfc}" ; then
            exit 1
        fi
    fi
    # Get icon
    case "${intfc}" in
        eth*|en*) pre='󰈀 ' ;;
        wifi*|wl*) pre=' ' ;;
        tether)   pre='󱇰 ' ;;
        blue*)    pre=' ' ;;
        lan*)     pre='󰒍 ' ;;
        *)        pre='󰛳 ' ;;
    esac
    # Get IP address for everybody
    txt="$(ip addr show "${intfc}" 2>/dev/null | awk '/inet/ {print $2}' | head -n 1)"
    if [ -z "${txt}" ] ; then
        txt='N/A'
    fi
    # Get SSID if also wireless
    if [ "${pre}" = ' ' ] ; then
        info="$(iwctl station "${intfc}" get-networks rssi-dbms \
            | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | sed --quiet '/^\s*>/p')"
        ssid="$(echo "${info}" | awk '{print $2}')"
        #strn="$(echo "${info}" | awk '{print $4}')"
        if [ -n "${ssid}" ] ; then
            txt="${ssid}  ${txt}"
        fi
    fi
    # Print info
    formatted_output
}
print_loop () {
    # Wrapper on listener that will do staggered prints
    # Subscribe to listener; and capture all stdin and stderr
    # First echo'd line will be the PID; so we can avoid orphans
    (ip monitor 2>&1 & echo "${!}" && wait) | (
        # Trap to kill the listener if parser loop is done
        trap 'kill "${_thispid}"; trap - EXIT' EXIT
        read -r _thispid
        # Do first line of printing, and record the time.
        print_info && _last="$(($(date '+%s%3N') - _bufdur))" || exit
        # Loop until listener breaks
        while ps -o pid= -p "${_thispid}" >/dev/null 2>&1 ; do
            # Wait until event
            grep --max-count=1 --quiet --line-buffered
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
