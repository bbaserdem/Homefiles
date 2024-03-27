# beets.nix

{
  directory = "~/Media/Audio/Music";
  library = "~/Media/Audio/Music/Beets_Library.db";
  ignore_hidden = false;
  asciify_paths = false;
  path_sep_replace = "⌿";
  replace = {
    "^-" = "_";           # Replace leading dash
    "^/"= "";             # Remove leading directory creator
    "^\\."= "";           # Remove leading dots
    "^\\s+"= "";          # remove trailing white-space
    "\\s+\$"= "";         # remove ending white-space
    "[\\x00-\\x1f]"= "";  # Remove control characters
    "<"=  "＜";           # Windows/Android restricted characters
    ">"=  "＞";
    ":"=  "∶";
    "\""=  "″";
    "\\?"= "⁇";
    "\\*"= "✱";
    "\\|"= "￨";
    "\\\\"= "⍀";
    "\\.\\.\\."= "…";      # Other replacements
    "&"=  "＆";
  };
  threaded = true;
  sort_item = [
    "albumartist+"
    "artist+"
    "album+"
    "disc+"
    "track+"
  ];
  sort_case_insensitive = false;
  artist_credit = true;
  per_disc_numbering = true;
  # UI options
  ui = {
    color = true;
  };
  # Importer options
  import = {
    write = true;
    move = true;
    resume = "ask";
    from_scratch = false;
    quiet = false;
    quiet_fallback = "asis";
    log = "~/.cache/beets/log";
    default_action = "skip";
    languages = [
      "en"
      "tr"
      "jp"
    ];
    detail = false;
    duplicate_action = "ask";
    bell = true;
  };
  # Database options
  musicbrainz = {
    searchlimit = 10;
    extra_tags = [
      "year"
      "catalognum"
      "country"
      "media"
      "label"
    ];
    genre = true;
    user = "silverbluep";
    pass = "";
  };
  # Autotagger matching
  match = {
      strong_rec_thresh = 0.04;
  };
  # Plugins
  pluginpath = "~/.config/beets/beetsplug";
  plugins = [
    "badfiles"
    "convert"
    "duplicates"
    "info"
    "missing"
    "edit"
    "fetchart"
    "embedart"
    "importadded"
    "lyrics"
    "mbsync"
    "mpdstats"
    "replaygain"
    "zero"
    "playlist"
    "smartplaylist"
    "mpdupdate"
    "the"
    "thumbnails"
    "types"
    "sbp"
    "alternatives"
    "copyartifacts"
  ];
  # Plugin configs
convert:
  auto: no
  copy_album_art: yes
  album_art_maxwidth: 256
  dest: ~/Sort/Converted_Music
  never_convert_lossy_files: yes
  embed: yes
  delete_originals: false
  format: opus
  formats:
    opus:
      command: ffmpeg -i $source -y -vn -acodec libopus -ab 192k $dest
      extension: opus

badfiles:
  check_on_import: yes
  commands:
    flac: flac --test --warnings-as-errors --silent

fetchart:
  auto: yes
  sources:
    - filesystem
    - coverart: release
    - itunes
    - coverart: releasegroup
    - albumart
    - amazon
    - wikipedia
    - '*'
  high_resolution: yes
  store_source: yes

embedart:
  auto: yes
  ifempty: no
  maxwidth: 256
  remove_art_file: no

lyrics:
  auto: yes
  force: no
  sources: lrclib genius
  synced: yes

mpd:
  rating: yes

replaygain:
  auto: yes
  backend: ffmpeg
  overwrite: no

zero:
  auto: yes
  comments: [EAC, LAME, from.+collection, 'ripped by']
  fields: comments
  update_database: true

playlist:
  auto: yes
  playlist_dir: ~/Media/Audio/Music/Playlists

smartplaylist:
  auto: yes
  playlist_dir: ~/Media/Audio/Music/Playlists
  relative_to: ~/Media/Audio/Music
  playlists:
    - name: JoeyFavs.m3u
      album_query: 'introducer:Joseph Hirsh'
      query: 'introducer:Joseph Hirsh'
    - name: Mood-Instrumental.m3u
      album_query: 'mood:instrumental'
    - name: Mood-Microtonal.m3u
      album_query: 'mood:microtonal'
    - name: Mood-Affirmation.m3u
      album_query: 'mood:affirmation'
    - name: Mood-Heavy.m3u
      album_query: 'mood:heavy'
    - name: Mood-Turkish.m3u
      album_query: 'mood:turkish'
    - name: Mood-Japanese.m3u
      album_query: 'mood:japanese'
    - name: Mood-Ambient.m3u
      album_query: 'mood:ambient'
    - name: Mood-Electronic.m3u
      album_query: 'mood:electronic'
    - name: Mood-Space.m3u
      album_query: 'mood:space'
    - name: Mood-Phonk.m3u
      album_query: 'mood:phonk'
    - name: Mood-Trippy.m3u
      album_query: 'mood:trippy'
    - name: Mood-Gag.m3u
      album_query: 'mood:gag'

thumbnails:
  auto: yes
  force: no

types:
  phone: bool
  dap: bool
  game: bool

copyartifacts:
  extensions: .*
  print_ignored: yes

alternatives:
  phone:
    directory: /home/sbp/Shared/Android/Music
    formats: opus mp3 ogg
    query: "phone:True"
    removable: false

# Path specifications
paths:
  default: '${initial}/%tdot{%the{${albumartist}}}/%if{${division},${division}/}%if{$date,[${date}] }%tdot{${album}%aunique{albumartist album,albumdisambig}}/%if{${tracknumber},${tracknumber}. }${title} - ${artist}'
  comp: '${initial}/%tdot{%the{${albumartist}}}/%if{${division},${division}/}%if{$date,[${date}] }%tdot{${album}%aunique{albumartist album,albumdisambig}}/%if{${tracknumber},${tracknumber}. }${title} - ${artist}'
  singleton: '[${initial}]/%tdot{%the{${albumartist}}}/%if{$date,[${date}] }${title} - ${artist}'
