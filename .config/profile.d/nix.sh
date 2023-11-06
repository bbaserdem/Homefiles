# Add nix manually to path
export PATH="${HOME}/.nix-profile/bin:${PATH}"
# Let Desktop environment to run things
export XDG_DATA_DIRS="${HOME}/.nix-profile/share:${XDG_DATA_DIRS}"
