import os
import sys
import filecmp

import beets.util
from beets import config
from beets.ui import get_path_formats
from mediafile import TYPES
from beets.plugins import BeetsPlugin
from beets.library import DefaultTemplateFunctions
from beets.util.functemplate import Template

__version__ = '0.1.2'
__author__ = 'Sami Barakat <sami@sbarakat.co.uk>'

class CopyArtifactsPlugin(BeetsPlugin):
    def __init__(self):
        super(CopyArtifactsPlugin, self).__init__()

        self.config.add({
            'extensions': '.*',
            'print_ignored': False
        })

        self._process_queue = []
        self._dirs_seen = []

        self.extensions = self.config['extensions'].as_str_seq()
        self.print_ignored = self.config['print_ignored'].get()

        self.path_formats = [c for c in beets.ui.get_path_formats() if c[0][:4] == u'ext:']

        self.register_listener('item_moved', self.collect_artifacts)
        self.register_listener('item_copied', self.collect_artifacts)
        self.register_listener('cli_exit', self.process_events)

    def _destination(self, filename, mapping):
        '''Returns a destination path a file should be moved to. The filename
        is unique to ensure files aren't overwritten. This also checks the
        config for path formats based on file extension allowing the use of
        beets' template functions. If no path formats are found for the file
        extension the original filename is used with the album path.
            - ripped from beets/library.py
        '''
        file_ext = os.path.splitext(filename)[1]

        for query, path_format in self.path_formats:
            query_ext = '.' + query[4:]
            if query_ext == file_ext.decode('utf8'):
                break
        else:
            # No query matched; use original filename
            file_path = os.path.join(mapping['albumpath'].encode('utf-8'), filename)
            return file_path

        if isinstance(path_format, Template):
            subpath_tmpl = path_format
        else:
            subpath_tmpl = Template(path_format)

        # Get template funcs and evaluate against mapping
        funcs = DefaultTemplateFunctions().functions()
        file_path = subpath_tmpl.substitute(mapping, funcs) + file_ext.decode('utf8')

        # Sanitize filename
        filename = beets.util.sanitize_path(os.path.basename(file_path))
        dirname = os.path.dirname(file_path)
        file_path = os.path.join(dirname, filename).encode('utf-8')

        return file_path

    # XXX: may be better to use FormattedMapping class from beets/dbcore/db.py
    def _get_formatted(self, value):
        '''Replace path separators in value
            - ripped from beets/dbcore/db.py
        '''
        sep_repl = beets.config['path_sep_replace'].as_str()
        for sep in (os.path.sep, os.path.altsep):
            if sep:
                value = value.replace(sep, sep_repl)

        return value

    def _generate_mapping(self, item, album_path):
        mapping = {
            'artist': item.artist or u'None',
            'albumartist': item.albumartist or u'None',
            'album': item.album or u'None',
        }
        for key in mapping:
            mapping[key] = self._get_formatted(mapping[key])

        mapping['albumpath'] = beets.util.displayable_path(album_path)

        return mapping

    def collect_artifacts(self, item, source, destination):
        source_path = os.path.dirname(source)
        dest_path = os.path.dirname(destination)

        # Check if this path has already been processed
        if source_path in self._dirs_seen:
            return

        non_handled_files = []
        for root, dirs, files in beets.util.sorted_walk(
                    source_path, ignore=config['ignore'].as_str_seq()):
            for filename in files:
                source_file = os.path.join(root, filename)

                # Skip any files extensions handled by beets
                file_ext = os.path.splitext(filename)[1]
                if len(file_ext) > 1 and file_ext.decode('utf8')[1:] in TYPES:
                    continue

                non_handled_files.append(source_file)

        self._process_queue.extend([{
            'files': non_handled_files,
            'mapping': self._generate_mapping(item, dest_path)
        }])
        self._dirs_seen.extend([source_path])

    def process_events(self):
        for item in self._process_queue:
            self.process_artifacts(item['files'], item['mapping'], False)

    def process_artifacts(self, source_files, mapping, reimport=False):
        if len(source_files) == 0:
            return

        ignored_files = []
        source_path = os.path.dirname(source_files[0])

        for source_file in source_files:
            # os.path.basename() not suitable here as files may be contained
            # within dir of source_path
            filename = source_file[len(source_path)+1:]

            dest_file = self._destination(filename, mapping)

            # Skip as another plugin or beets has already moved this file
            if not os.path.exists(source_file):
                ignored_files.append(source_file)
                continue

            # Skip extensions not handled by plugin
            file_ext = os.path.splitext(filename)[1]
            if ('.*' not in self.extensions
                and file_ext.decode('utf8') not in self.extensions):
                ignored_files.append(source_file)
                continue

            # Skip file if it already exists in dest
            if (os.path.exists(dest_file)
                and filecmp.cmp(source_file, dest_file)):
                ignored_files.append(source_file)
                continue

            dest_file = beets.util.unique_path(dest_file)
            beets.util.mkdirall(dest_file)
            dest_file = beets.util.bytestring_path(dest_file)

            # TODO: detect if beets was called with 'move' and override config
            # option here

            if config['import']['move']:
                self._move_artifact(source_file, dest_file)
            else:
                if reimport:
                    # This is a reimport
                    # files are already in the library directory
                    self._move_artifact(source_file, dest_file)
                else:
                    # A normal import, just copy
                    self._copy_artifact(source_file, dest_file)


        if self.print_ignored and ignored_files:
            self._log.warning(u'Ignored files:')
            for f in ignored_files:
                self._log.warning('   {0}', os.path.basename(f))

    def _copy_artifact(self, source_file, dest_file):
        self._log.info(u'Copying artifact: {0}'.format(os.path.basename(dest_file.decode('utf8'))))
        beets.util.copy(source_file, dest_file)

    def _move_artifact(self, source_file, dest_file):
        if not os.path.exists(source_file):
            # Sanity check for other plugins moving files
            return

        self._log.info(u'Moving artifact: {0}'.format(os.path.basename(dest_file.decode('utf8'))))
        beets.util.move(source_file, dest_file)

        dir_path = os.path.split(source_file)[0]
        beets.util.prune_dirs(dir_path, clutter=config['clutter'].as_str_seq())

