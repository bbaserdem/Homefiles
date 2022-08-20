#!/bin/bash
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IF=$'\t'

fix_perm () {
    # Manage permission of home folder
    chmod u=rwX,g=r,o=r "${HOME}"
    if [ -d "${HOME}/.ssh" ] ; then
        chmod --recursive u=rwX,g=,o= "${HOME}/.ssh"
    fi
    if [ -d "${HOME}/.local/ssh" ] ; then
        chmod --recursive u=rwX,g=,o= "${HOME}/.local/ssh"
    fi
    if [ -d "${HOME}/.local/gnupg" ] ; then
        chmod --recursive u=rwX,g=,o= "${HOME}/.local/gnupg"
    fi
    if [ -d "${XDG_CONFIG_HOME}/gnugp" ] ; then
        chmod --recursive u=rwX,g=,o= "${XDG_CONFIG_HOME}/gnugp"
    fi
    if [ -f "${HOME}/.face" ] ; then
        chmod u=rwX,g=r,o=r "${HOME}/.face"
    fi
    if [ -f "${HOME}/.face.icon" ] ; then
        chmod u=rwX,g=r,o=r "${HOME}/.face.icon"
    fi
}

symlinks_and_directories () {
    # Place symlinks
    echo 'Creating directories and symlinks. . .'
    mkdir --parents "${HOME}/.cache/"{mpd,isync,mpdscribble,vdirsyncer,newsboat}
    mkdir --parents "${HOME}/.icons/default"

    # Fallback values for bash shell
    ln --symbolic --force "${HOME}/.config/bash/bashrc" "${HOME}/.bashrc"
    ln --symbolic --force "${HOME}/.config/bash/login"  "${HOME}/.bash_profile"
    ln --symbolic --force "${HOME}/.config/bash/logout" "${HOME}/.bash_logout"

    # Things for Xorg/Login manager
    ln --symbolic --force "${HOME}/.config/X11/clientrc"    "${HOME}/.xinitrc"
    ln --symbolic --force "${HOME}/.config/X11/serverrc"    "${HOME}/.xserverrc"
    ln --symbolic --force "${HOME}/.config/X11/resources"   "${HOME}/.Xresources"
    ln --symbolic --force "${HOME}/.config/X11/profile"     "${HOME}/.xprofile"
    ln --symbolic --force "${HOME}/.config/X11/session"     "${HOME}/.xsession"
    ln --symbolic --force "${HOME}/.config/X11/keymap"      "${HOME}/.Xkbmap"

    # Non-xdg-compliant configuration options
    ln --symbolic --force "${HOME}/.config/gtk-2.0/gtkrc"       "${HOME}/.gtkrc-2.0"
    ln --symbolic --force "${HOME}/.config/cursor/index.theme"  "${HOME}/.icons/default/index.theme"
    ln --symbolic --force "${HOME}/.config/latex/latexmkrc"     "${HOME}/.latexmkrc"
    ln --symbolic --force "${HOME}/.config/matlab"              "${HOME}/.matlab"
    ln --symbolic --force "${HOME}/.config/tmux.conf"           "${HOME}/.tmux.conf"

    # Setting profile picture
    ln --symbolic --force "${HOME}/Pictures/Profile/Linux_login_profile" "${HOME}/.face"
    ln --symbolic --force "${HOME}/Pictures/Profile/Linux_login_profile" "${HOME}/.face.icon"
}

local_update () {
    # Syncthing ignore
    echo "Generating syncthing ignore files"
    _stfold=("${HOME}/Pictures" "${HOME}/Documents" "${HOME}/Work" "${HOME}/Music" "${HOME}/Videos")
    for _fl in "${_stfold[@]}" ; do
        if [ -e "${_fl}/.stignore" ] ; then
            mv "${_fl}/.stignore" "${_fl}/stignore.$(date '+%Y-%m-%d_%Hh%Mm%Ss').bak"
            echo "Existing file backed up."
        fi
        # Create/clear stignore file
        echo "// Syncthing ignore file"             >  "${_fl}/.stignore"
        if [ -e "${_fl}/Stignore/general" ] ; then
            echo "// Ignore generic stuff"          >> "${_fl}/.stignore"
            echo "#include Stignore/general"        >> "${_fl}/.stignore"
        fi
        # Strip hostname
        _name="$(hostname | sed -n 's|sbp-\([a-z,A-Z]*\)-\(.*\)|\2|p')"
        if [ ! -z "${_name}" ]; then
            if [ -e "${_fl}/Stignore/${_name}" ] ; then
                echo "// Block files according to ${_name}" >> "${_fl}/.stignore"
                echo "#include Stignore/${_name}"                     >> "${_fl}/.stignore"
            fi
        fi
    done

    # Generator scripts for passwords
    echo "Generating local password files . . ."
    ${HOME}/.local/bin/isync-passgen.sh
    ${HOME}/.local/bin/vdirsyncer-passgen.sh
    ${HOME}/.local/bin/s3cfg-gen.sh

    # Initialize vdirsyncer
    echo "Initializing vdirsyncer . . ."
    vdirsyncer discover calendar
    vdirsyncer discover contacts
}

archive_keys () {
    # Function to do a backup of various keys in the home folder
    _name="$(hostname | sed -n 's|sbp-\([a-z,A-Z]*\)-\(.*\)|\2|p')"
    _tgt="Keys_${_name}.tar"
    if [ -f "${HOME}/${_tgt}" ] ; then
        mv "${HOME}/${_tgt}" "${HOME}/${_tgt}_old_$(date '+%Y-%m-%d_%Hh%Mm%Ss')"
    fi

    # Change to home directory
    cd "${HOME}" || exit

    # Create archive
    tar --create --file "${_tgt}" --files-from /dev/null

    # Add SSH keys
    tar --append --file "${_tgt}" "${HOME}/.ssh"

    # Add gpg keys
    if [ -z "${GNUPGHOME}" ] ; then
        tar --append --file "${_tgt}" "${XDG_DATA_HOME}/gnupg"
    else
        tar --append --file "${_tgt}" "${GNUPGHOME}"
    fi

    # Add syncthing config files
    if [ -z "${XDG_CONFIG_HOME}" ] ; then
        _syn=".config/syncthing"
    else
        _syn="${XDG_CONFIG_HOME}/syncthing"
    fi
    _cer=('cert.pam' 'config.xml' 'csrftokens.txt' 'https-cert.pem' 'https-cert.pem' 'key.pem')
    for _file in "${_cer[@]}" ; do
        if [ -f "${_syn}/${_file}" ] ; then
            tar --append --file "${_tgt}" "${_syn}/${_file}"
        fi
    done

    cd - || exit
}

extract_keys () {
    _name="$(hostname | sed -n 's|sbp-\([a-z,A-Z]*\)-\(.*\)|\2|p')"
    _tgt="Keys_${_name}.tar"
    if [ ! -f "${_tgt}" ] ; then
        echo "Archive not found, ${_tgt}"
    else
        tar --extract --file "${_tgt}" --directory "${HOME}"
    fi
}

run_all () {
    fix_perm
    symlinks_and_directories
    local_update
}

# Help text
print_usage() {
    echo "Usage:"
    echo "    -p            Fix (p)ermissions"
    echo "    -l            Do sym(l)inks and directories"
    echo "    -u            (U)pdate local packages and configs"
    echo "    -s (default)  Full (s)etup (do all options besides keys)"
    echo "    -h            Display this (h)elp message"
    echo "    -a            Backup an (a)rchive of private keys"
    echo "    -e            (E)xtract keys from backup"
}

if [ -z "${1}" ] ; then
    echo "No flags set, defaulting to full config"
    run_all
else
    while getopts ':plushae' flag; do
        case "${flag}" in
            p) fix_perm ;;
            l) symlinks_and_directories ;;
            u) local_update ;;
            s) run_all ;;
            h) print_usage ;;
            a) archive_keys ;;
            e) extract_keys ;;
            *) echo "Unknown option ${flag}"; print_usage ; exit 1 ;;
        esac
    done
fi
