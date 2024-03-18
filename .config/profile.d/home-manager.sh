# Home manager source script with guards
if [ -d "${HOME}/.nix-profile/etc/profile.d" ] ; then
    source "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
