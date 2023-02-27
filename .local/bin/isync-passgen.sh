#!/bin/sh

# The output script file
_fdir="${XDG_CACHE_HOME}/isync"
_ufile="${_fdir}/eaddress-google.sh"
_pfile="${_fdir}/password-google.sh"

# Create directory if not there
if [ ! -z "${_fdir}" ] ; then
    mkdir --parents "${_fdir}"
fi

# If the script exists, delete it
[ -z "${_ufile}" ] && rm "${_ufile}"
[ -z "${_pfile}" ] && rm "${_pfile}"

# Echo appropriate lines to the script
echo "#!/bin/sh" > "${_ufile}"
echo "#!/bin/sh" > "${_pfile}"
echo "echo '$(pass Google | awk '/^email:/ {print $2}')'" >> "${_ufile}"
echo "echo '$(pass Google | awk '/^isync:/ {print $2}')'" >> "${_pfile}"

# Make executable
chmod 700 "${_ufile}"
chmod 700 "${_pfile}"
