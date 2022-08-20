#!/bin/dash
# This script refreshes backdrop of desktops when called
# Either say refresh; which then refreshes background,
# Or theme; which only grabs the correct themed wallpaper
imfind_dir () {
    find "${1}" -type f -a '(' \
        -iname "${_theme}*.jpg"  -o \
        -iname "${_theme}*.jpeg" -o \
        -iname "${_theme}*.png" ')' -print 2>/dev/null \
        | shuf -n 1 -
}

# Get rectangle information of the screen
_rect="$(xdpyinfo | awk '/dimensions/ {print $2;}')"
_x="$(echo "${_rect}" | sed 's|\([0-9]*\)x\([0-9]*\)|\1|')"
_y="$(echo "${_rect}" | sed 's|\([0-9]*\)x\([0-9]*\)|\2|')"

# Set a theme, or check if things are to be refreshed
_theme=''
_img=''
_oldimg="${XDG_CACHE_HOME}/last_xpaper"
_thisdir=''
if [ "${1}" = 'reload' ] && [ -L "${_oldimg}" ] ; then
    _img="$(readlink "${_oldimg}")"
elif [ -n "${1}" ] ; then
    if [ -d "${1}" ] ; then
        _thisdir="${1}"
        if [ -n "${2}" ] ; then
            _theme="${2}"
        fi
    else
        _theme="${1}"
    fi
fi
_base="$(xdg-user-dir PICTURES)"
if [ -z "${_base}" ] || [ "${_base}" = "${HOME}" ] ; then
    _base="${HOME}/Pictures"
fi

if [ -n "${_img}" ] ; then
    # Use old image if already loaded
    true
elif [ -n "${_thisdir}" ]; then
    # Do this on the asked directory if asked
    if [ -d "${_thisdir}/${_x}x${_y}" ] ; then
        _img="$(imfind_dir "${_thisdir}/${_x}x${_y}")"
    else
        _img="$(imfind_dir "${_thisdir}")"
    fi
elif [ -n "${SBP_XPAPER_DIR}" ] && [ -d "${_base}/${SBP_XPAPER_DIR}" ]; then
    # Try to find image; if a dir is specified
    if [ -d "${_base}/${SBP_XPAPER_DIR}/${_x}x${_y}" ] ; then
        _img="$(imfind_dir "${_base}/${SBP_XPAPER_DIR}/${_x}x${_y}")"
    else
        _img="$(imfind_dir "${_base}/${SBP_XPAPER_DIR}")"
    fi
else
    # If the dir is not specified; try to find one in other locations
    if [ -d "/usr/share/backgrounds/${_x}x${_y}" ] ; then
        _img="$(imfind_dir "/usr/share/backgrounds/${_x}x${_y}")"
    elif [ -d '/usr/share/backgrounds' ] ; then
        _img="$(imfind_dir '/usr/share/backgrounds')"
    elif [ -d "${_base}/Wallpapers/${_x}x${_y}" ] ; then
        _img="$(imfind_dir "${HOME}/Wallpapers/${_x}x${_y}")"
    elif [ -d "${_base}/Wallpapers" ] ; then
        _img="$(imfind_dir "${HOME}/Wallpapers")"
    fi
fi

# Error; there is no image
if [ -z "${_img}" ] ; then
    echo "No image was found"
    exit 3
fi

# Save the background location, for quick setting in the future
if [ "${_img}" != "${_oldimg}" ] ; then
    ln --symbolic --force "${_img}" "${_oldimg}"
else
    rm --force "${_oldimg}"
fi

# Set without using Xinerama
feh --no-fehbg --bg-scale --no-xinerama "${_img}"
