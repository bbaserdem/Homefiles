#!/bin/dash

# Execute the following if the window manager is bspwm
if [ "${XDG_CURRENT_DESKTOP}" = 'bspwm' ] ; then
    # Select the xrdb file to read
    xrdb "${XDG_CONFIG_HOME}/X11/resources"
    if [ "${AUTORANDR_CURRENT_PROFILE}" = 'Work-AtHome-Hidef' ] ; then
        xrdb -merge "${XDG_CONFIG_HOME}/X11/uhd.resources"
    fi
    
    chill_file="${XDG_CACHE_HOME}/autorandr_chill"
    if [ -f "${chill_file}" ] ; then
        # Bspwm just loaded; just undo the chill
        rm --force "${chill_file}"
    else
        # Refresh desktop
        bspwmctl refresh
        # Send notification
        notify-send 'Autorandr' 'BSPWM: refreshed layout' --icon=display
    fi
fi
