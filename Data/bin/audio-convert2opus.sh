#!/bin/dash
# Conversion script; meant to be used with beets

# Just guards if source and dest are not defined as environment vars
if [ -z "${source}" ] ; then source="${1}" ; fi
if [ -z "${dest}"   ] ; then   dest="${2}" ; fi

# Converts a file, given by $source to opus, into $dest
case "${source}" in
    *.mp3)
        _irate="$(exiftool -AudioBitrate "${source}" | sed 's|[^0-9]*\([0-9]\+\) kbps.*|\1|')"
        # Choose output bitrate
        if   [ "${_irate}" -ge 300 ] ; then
            _orate='192k'
        elif [ "${_irate}" -ge 200 ] ; then
            _orate='128k'
        else
            _orate='96k'
        fi 
        ;;
    *.flac) _orate='256k' ;;
    *.m4u)  _orate='192k' ;;
    *.opus) _orate='keep' ;;
    *.ogg)  _orate='keep' ;;
    *)      _orate='96k'  ;;
esac

if [ "${_orate}" = 'keep' ] ; then
    copy "${source}" "${dest}"
else
    ffmpeg -i "${source}" \
        -codec:a libopus -b:a "${_orate}" -vbr on \
        "${dest}"
fi
