"""SBP Plugin; my personal plugin for managing my media files."""

import re
from beets.plugins import BeetsPlugin
from beets.dbcore import types
import mediafile


class MyPlugin(BeetsPlugin):
    """Plugin object."""

    def __init__(self):
        """Self definition."""
        super(MyPlugin, self).__init__()
        self.template_fields['tracknumber'] = _full_track
        self.template_fields['trackdate'] = _date
        self.template_fields['division'] = _division
        self.template_fields['storage_track'] = _archive_field
        self.album_template_fields['date'] = _date
        self.album_template_fields['initial'] = _initial
        self.album_template_fields['adiv'] = _division
        self.album_template_fields['storage'] = _archive_field
        # Add field named series
        _series = mediafile.MediaField(
            mediafile.MP3DescStorageStyle('Series'),
            mediafile.StorageStyle('SERIES'),
            out_type=int
        )
        self.add_media_field('series', _series)
        # Remove trailing dot replacer
        self.template_funcs['tdot'] = _trailing_dots

def _full_track(item):
    """Track name.

    Expand to disc, then track number with proper padding.
    Do this with the proper amount of padding.
    """

    def int_text(this_int, this_lim):
        return ('%0' + str(len(str(this_lim))) + 'i') % this_int
    if item.tracktotal > 99:
        tracks = int_text(item.track, item.tracktotal)
    else:
        tracks = f'{item.track:02}'
    if item.disctotal > 1:
        return int_text(item.disc, item.disctotal) + '-' + tracks
    return tracks


def _date(item):
    """Expand this to the date field, which populates on available info."""
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
    return ''


def _initial(item):
    """Parse the album to provide an initial field."""
    art = item.albumartist
    initial = re.sub(r'^(the|a|an) ', '', art, flags=re.IGNORECASE)[0].upper()
    # Overwrites
    if art == 'Various Artists':
        initial = '@'
    elif art == 'Şuradan Buradan':
        initial = '@'
    elif not (initial.isascii() and initial.isalnum()):
        initial = '_'
    elif initial.isnumeric():
        initial = '#'
    # Return the initial; indexed by brackets
    return initial


def _division(item):
    """Create the album's subdivision if needed to create one."""
    this_type = item.albumtypes
    this_artist = item.albumartist
    if hasattr(item, 'series'):
        this_series = item['series']
    else:
        this_series = ''
    if this_series:
        return this_series
    elif 'single' in this_type:
        return 'Singles'
    elif 'ep' in this_type:
        return 'EPs'
    elif 'dj-mix' in this_type:
        return 'Remixes'
    elif 'remix' in this_type:
        return 'Remixes'
    elif 'live' in this_type:
        return 'Live'
    elif 'mixtape' in this_type:
        return 'Demos'
    elif 'street' in this_type:
        return 'Demos'
    elif 'demo' in this_type:
        return 'Demos'
    elif 'interview' in this_type:
        return 'Streams'
    elif 'broadcast' in this_type:
        return 'Streams'
    elif ('Various Artists' not in this_artist) and 'compilation' in this_type:
        return 'Compilations'
    else:
        return ''


def _archive_field(item):
    """Spit separatory directory if needed."""
    if hasattr(item, 'archive'):
        if item.archive == '1':
            return 'Archive'
    return ''


def _trailing_dots(text):
    """Replace trailing dots with non-ascii dots."""
    if text[-1] == '.':
        return text + '_'
    else:
        return text
