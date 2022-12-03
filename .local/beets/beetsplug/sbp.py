from beets.plugins import BeetsPlugin
import re
import mediafile


class MyPlugin(BeetsPlugin):
    def __init__(self):
        super(MyPlugin, self).__init__()
        self.template_fields['tracknumber'] = _full_track
        self.template_fields['trackdate'] = _date
        self.album_template_fields['date'] = _date
        self.album_template_fields['initial'] = _initial
        _series = mediafile.MediaField(
            mediafile.MP3DescStorageStyle('Series'),
            mediafile.StorageStyle('SERIES')
        )
        self.add_media_field('series', _series)

        # self.album_album_fields['division'] = _division
        # self.album_album_fields['division'] = _division


def _full_track(item):
    """
    Expand to disc, then track number with proper padding.
    Do this with the proper amount of padding.
    """
    def int_text(this_int, this_lim):
        return ('%0' + str(len(str(this_lim))) + 'i') % this_int

    tracks = int_text(item.track, item.tracktotal)
    if item.disctotal > 1:
        return int_text(item.disc, item.disctotal) + '-' + tracks
    else:
        return tracks


def _date(item):
    """ Expand this to the date field, which populates on available info
    """
    if item.year:
        this_year = str(item.year)
        if item.month:
            this_month = '-%02i' % item.month
            if item.day:
                this_day = '-%02i' % item.day
            else:
                this_day = ''
        else:
            this_month = ''
            this_day = ''
        return this_year + this_month + this_day
    else:
        return ''


def _initial(item):
    """
    Parse the album to provide an initial field
    """
    art = item.albumartist
    initial = re.sub(r'^(the|a|an) ', '', art, flags=re.IGNORECASE)[0].upper()
    # Overwrites
    if art == 'Various Artists':
        initial = '@'
    elif art == 'Şuradan Buradan':
        initial = '@'
    elif not (initial.isascii() and initial.alnum()):
        initial = '_'
    elif initial.isnumeric():
        initial = '#'
    # Return the initial; indexed by brackets
    return '[' + initial + ']'
