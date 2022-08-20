#!/bin/dash
# vim:ft=sh

# Kill all descendents on exit
trap 'exit' INT TERM
trap 'kill 0' EXIT

###################
#    _ _     _    #
#  _| |_|___| |_  #
# | . | |_ -| '_| #
# |___|_|___|_,_| #
###################
# Disk module;
#  * Needs the an argument either of target; or root/home
if [ -z "${SYSINFO_DISK_POLL}" ] ; then
    SYSINFO_DISK_POLL=900
fi
click_right  () {
    ( flock --nonblock 7 || exit 7
        if [ -x '/usr/bin/baobab' ] ; then
            /usr/bin/baobab
        fi
    ) 7>"${SYSINFO_FLOCK_DIR}/${name}_${IDENTIFIER}_right" >/dev/null 2>&1 &
}
print_info () {
    # Example pre-amble
    pre=' '
    suf=''
    txt=''
    # Some overrides for locations based on hostname
    if uname -n | grep --quiet --regexp 'sbp-.*-laptop' 2>/dev/null ; then
        if [ "${instance}" = 'home' ] ; then
            instance='quit'
        elif [ "${instance}" = 'archive' ] ; then
            instance='data'
        elif [ "${instance}" = 'root' ] ; then
            instance='filesystem-btrfs'
        fi
    fi
    # Utilize some predetermined quantifiers
    if [ -d "${instance}" ] ; then
        dir="${instance}"
        txt="$(basename "${instance}"): "
    elif [ "${instance}" = 'root' ] ; then
        pre='פּ '
        dir="/"
    elif [ "${instance}" = 'home' ] ; then
        pre=' '
        dir="/home"
    elif [ "${instance}" = 'archive' ] ; then
        pre=' '
        dir="/home/archive"
        txt="Archive: "
    elif [ "${instance}" = 'data' ] ; then
        pre=' '
        dir="/home/data"
        txt="Data: "
    elif [ "${instance}" = 'windows' ] ; then
        pre=' '
        dir="/mnt/windows"
    elif [ "${instance}" = 'filesystem-btrfs' ] ; then
        pre='פּ '
        dir="/mnt/filesystem-btrfs"
        txt="FS: "
    elif [ "${instance}" = 'quit' ] ; then
        empty_output
        exit 1
    fi
    # Check if directory exists and is a mount point
    if ! /bin/mountpoint --quiet "${dir}" ; then
        empty_output
        exit 1
    fi
    # Get filled percentage, use btrf is fs is btrfs
    if btrfs filesystem df "{dir}" 1>/dev/null 2>&1 ; then
        prc="$(btrfs filesystem usage "${dir}" 2>/dev/null | awk '
            BEGIN { size = 0; used = 0; }
            /Device size:/      { size = $3; }
            /Device allocated:/ { used = $3; }
            END { print int(100 * used / size); }')"
    else
        prc="$(df --human-readable --portability --local | awk '
            BEGIN { perc=0; } {
            if( $6 == "'"${dir}"'" ) { perc = substr($5, 1, length($5) - 1); }
            } END { print perc; }')"
    fi
    # Mark if FS is filled up
    if [ "${prc}" -gt 90 ] ; then
        feature='urgent'
        suf=' '
    fi
    txt="${txt}${prc}"
    # Print string
    formatted_output
}
print_loop () {
    while : ; do
        print_info || exit 2
        sleep "${SYSINFO_DISK_POLL}"
    done
}
