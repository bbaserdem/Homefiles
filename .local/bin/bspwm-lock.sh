#!/bin/bash
# Kill the locker if we are killed
trap 'kill %%' TERM INT

# Delay in seconds
_delay=1

# Hooks to locks
pre_lock() {
    #mpc pause
    return
}
post_lock() {
    return
}

# Directory generation
if [ -z "${XDG_CACHE_HOME}" ] ; then
    _dir="/tmp"
else
    _dir="${XDG_CACHE_HOME}/sbp-bspwm-lock"
    if [ -x "${_dir}" ] && [ ! -d "${_dir}" ] ; then
        echo 'Cache directory is a file'
        exit 1
    elif [ ! -x "${_dir}" ] ; then
        mkdir --parents "${_dir}"
    fi
fi

# Lock function
this_lock() {
    _lock="${_dir}/screenlock.at.${DISPLAY}"
    ( 
        flock --nonblock --exclusive 9 || exit 1
        #---Get necessary paths
        _img="${_dir}/lockscreen.png"
        _lock="${_dir}/screenlock.at.${DISPLAY}"
        #---Get screenshot and pixellate
        maim | convert - -scale 10% -scale 1000% "${_img}"
        #---Compose an image on top
        # convert $TMPBG $ICON -gravity center -composite -matte $TMPBG
        #---Lock the screen
        i3lock --image="${_img}" \
            --pointer=default \
            --ignore-empty-password \
            --show-failed-attempts \
            --indicator \
            --keylayout 0 \
            --clock \
            --pass-power-keys \
            --pass-media-keys \
            --pass-screen-keys \
            --radius 180 \
            --bar-indicator --bar-width=50
    ) 9>"${_lock}"
}

# Run the pre-lock hook
pre_lock

if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]] ; then
    # We are being locked by xss due to sleep

    # Lock without inheriting the sleep lock
    this_lock {XSS_SLEEP_LOCK_FD}<&- &

    # Delay sleep this much
    sleep "${_delay}"

    # Close our fd to indicate we're ready to sleep
    exec {XSS_SLEEP_LOCK_FD}<&-
else
    # Lock with no frills
    this_lock &
fi

# Wait for the locker to finish it's thing
wait

# Post-lock hook
post_lock
