#!/usr/bin/python

"""
Personal qutebrowser configuration
"""

from socket import gethostname as ghn
import datetime

# Don't load autoconfig
config.load_autoconfig(False)

# Search engines
c.url.searchengines = {
    "DEFAULT"   : "https://duckduckgo.com/?q={}",
    "ar"        : "https://wiki.archlinux.org/?search={}",
    "ge"        : "https://wiki.gentoo.org/?search={}",
    "au"        : "https://aur.archlinux.org/packages/{}",
    "ma"        : "https://www.mathworks.com/help/matlab/ref/{}.html",
    "go"        : "https://www.google.com/search?hl=en&q={}",
    "wi"        : "https://www.wikipedia.org/wiki/{}",
    "am"        : "https://www.amazon.com/s?k={}",
    "scp"       : "http://www.scp-wiki.net/scp-{}"
}

# Start page; depending on location
if (ghn() == "sbp-arch-work") or (ghn() == "sbp-gentoo-work"):
    c.url.default_page = "http://intranet.cshl.edu"
    c.url.start_pages = ["http://intranet.cshl.edu"]
else:
    c.url.default_page = "https://start.duckduckgo.com/"
    c.url.start_pages = ["https://start.duckduckgo.com/"]

# Look and feel
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = 'never'
c.colors.webpage.darkmode.policy.page = 'smart'
c.colors.webpage.preferred_color_scheme = 'dark'
c.completion.height = "10%"
c.completion.scrollbar.padding = 3
c.completion.scrollbar.width = 10
c.downloads.position = 'top'
c.scrolling.bar = 'always'
c.scrolling.smooth = True
c.statusbar.position = 'top'
c.statusbar.show = 'always'
c.tabs.background = True
c.tabs.last_close = "startpage"
c.tabs.position = "left"
c.tabs.show = 'always'
c.tabs.title.format = '{aligned_index}{audio}: {current_title}'
c.tabs.width = "12%"

# Behavior settings
c.auto_save.session = True
c.changelog_after_upgrade = 'patch'
c.confirm_quit = ['always']
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.canvas_reading = False
c.content.desktop_capture = 'ask'
c.content.geolocation = 'ask'
c.content.javascript.alert = True
#c.content.javascript.clipboard = False
c.content.javascript.enabled = True
c.content.javascript.can_close_tabs = False
c.content.javascript.can_open_tabs_automatically = False
c.content.media.audio_capture = 'ask'
c.content.media.audio_video_capture = 'ask'
c.content.media.video_capture = 'ask'
c.content.mouse_lock = False
c.content.pdfjs = False
c.content.prefers_reduced_motion = True
c.content.tls.certificate_errors = 'ask-block-thirdparty'
c.downloads.location.prompt = True
c.downloads.location.suggestion = 'both'
c.downloads.open_dispatcher = 'xdg-open {}'
c.editor.command = ['kitty', 'nvim', '--cmd', 'normal {line}G{column0}l', '{file}']
c.input.insert_mode.plugins = True
c.session.lazy_restore = True
c.spellcheck.languages = ['en-US', 'tr-TR']

""" KEYBINDS """
# Update adblock list
config.bind(',b', 'adblock-update')
# MPV to watch streams
config.bind(',m', 'spawn --detach mpv {url}')
config.bind(',M', 'hint links spawn --detach mpv {hint-url}')
# Add quickmark
config.bind(',w', 'set-cmd-text --space :quickmark-add {url}')
# Insert password
pass_args = ' --username-target secret --username-pattern "user: (.+)" --dmenu-invocation rofi'
config.bind(',l', 'spawn --userscript qute-pass' + pass_args)
config.bind(',L', 'hint inputs userscript qute-pass' + pass_args)
config.bind(',u', 'spawn --userscript qute-pass --username-only' + pass_args)
config.bind(',U', 'hint inputs userscript qute-pass --username-only' + pass_args)
config.bind(',p', 'spawn --userscript qute-pass --password-only' + pass_args)
config.bind(',P', 'hint inputs userscript qute-pass --password-only' + pass_args)
# Download using uget
config.bind(',o', "spawn --detach uget-gtk --quiet --folder=Data/Downloads '{url}'")
config.bind(',O', "hint links spawn uget-gtk --quiet --folder=Data/Downloads '{hint-url}'")
config.bind('o', "prompt-yank --sel;;spawn --detach uget-gtk --quiet --folder=Data/Downloads '{primary}';;mode-enter normal", mode='prompt')
# Colorscheme mapping; use ctrl-d to change theme
css_dark = str(config.configdir) + '/css/dark.css'
css_light = str(config.configdir) + '/css/light.css'
config.bind(',d', 'config-cycle --temp content.user_stylesheets {0} {1} "" ;; reload'.format(css_dark, css_light))

# base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
# Base16 qutebrowser template by theova
# Tomorrow Night scheme by Chris Kempson (http://chriskempson.com)
base00 = "#1d1f21"
base01 = "#282a2e"
base02 = "#373b41"
base03 = "#969896"
base04 = "#b4b7b4"
base05 = "#c5c8c6"
base06 = "#e0e0e0"
base07 = "#ffffff"
base08 = "#cc6666"
base09 = "#de935f"
base0A = "#f0c674"
base0B = "#b5bd68"
base0C = "#8abeb7"
base0D = "#81a2be"
base0E = "#b294bb"
base0F = "#a3685a"
# set qutebrowser colors
c.colors.completion.category.bg = base00
c.colors.completion.category.border.bottom = base00
c.colors.completion.category.border.top = base00
c.colors.completion.category.fg = base0A
c.colors.completion.fg = base05
c.colors.completion.item.selected.bg = base0A
c.colors.completion.item.selected.border.bottom = base0A
c.colors.completion.item.selected.border.top = base0A
c.colors.completion.item.selected.fg = base01
c.colors.completion.match.fg = base0B
c.colors.completion.odd.bg = base00
c.colors.completion.even.bg = base00
c.colors.completion.scrollbar.bg = base00
c.colors.completion.scrollbar.fg = base05
c.colors.downloads.bar.bg = base00
c.colors.downloads.error.fg = base08
c.colors.downloads.start.bg = base0D
c.colors.downloads.start.fg = base00
c.colors.downloads.stop.bg = base0C
c.colors.downloads.stop.fg = base00
c.colors.hints.bg = base0A
c.colors.hints.fg = base00
c.colors.hints.match.fg = base05
c.colors.keyhint.bg = base00
c.colors.keyhint.fg = base05
c.colors.keyhint.suffix.fg = base05
c.colors.messages.error.fg = base00
c.colors.messages.error.bg = base08
c.colors.messages.error.border = base08
c.colors.messages.info.bg = base00
c.colors.messages.info.border = base00
c.colors.messages.info.fg = base05
c.colors.messages.warning.bg = base0E
c.colors.messages.warning.border = base0E
c.colors.messages.warning.fg = base00
c.colors.prompts.bg = base00
c.colors.prompts.border = base00
c.colors.prompts.fg = base05
c.colors.prompts.selected.bg = base0A
c.colors.statusbar.caret.bg = base0E
c.colors.statusbar.caret.fg = base00
c.colors.statusbar.caret.selection.bg = base0D
c.colors.statusbar.caret.selection.fg = base00
c.colors.statusbar.command.bg = base00
c.colors.statusbar.command.fg = base05
c.colors.statusbar.command.private.bg = base00
c.colors.statusbar.command.private.fg = base05
c.colors.statusbar.insert.bg = base0D
c.colors.statusbar.insert.fg = base00
c.colors.statusbar.normal.bg = base00
c.colors.statusbar.normal.fg = base0B
c.colors.statusbar.passthrough.bg = base0C
c.colors.statusbar.passthrough.fg = base00
c.colors.statusbar.private.bg = base03
c.colors.statusbar.private.fg = base00
c.colors.statusbar.progress.bg = base0D
c.colors.statusbar.url.error.fg = base08
c.colors.statusbar.url.fg = base05
c.colors.statusbar.url.hover.fg = base05
c.colors.statusbar.url.success.http.fg = base0C
c.colors.statusbar.url.success.https.fg = base0B
c.colors.statusbar.url.warn.fg = base0E
c.colors.tabs.bar.bg = base00
c.colors.tabs.even.bg = base00
c.colors.tabs.odd.bg = base00
c.colors.tabs.even.fg = base05
c.colors.tabs.odd.fg = base05
c.colors.tabs.indicator.error = base09
c.colors.tabs.indicator.start = base0C
c.colors.tabs.indicator.stop = base0B
c.colors.tabs.selected.even.bg = base02
c.colors.tabs.selected.odd.bg = base02
c.colors.tabs.selected.even.fg = base05
c.colors.tabs.selected.odd.fg = base05
#c.colors.webpage.bg = base00
