# is_dir: mod:this is directory
#       written by T.Hayashi
##############################################################################
# Usage:
# is_dir
# RETUEN=`is_dir  "any_dir"`
# Tested on Ubunts(WSL),FreeBSD
#
# Not POSIX Commands:
#
# testing flags
is_dir_TEST=1
#DEBUG=1

is_dir() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: is_dir: require directory name"
    return 1
  fi
  local _MSG="directory"
  local _DIRNAME=${1}

   [ ${DEBUG} ] && echo "DEBUG(is_dir) dirname:${1}" >&2
  if [ ! -d "${_DIRNAME}" ]; then
    echo "Warn ${_DIRNAME} is not ${_MSG}"
    return 1
  else
    echo "OK ${_DIRNAME} is ${_MSG}"
    return 0
  fi
}

##### TEST CODE
if [ ${is_dir_TEST} ]; then
  is_dir "/etc"         # dir
  echo "Exit status is ${?}"
  is_dir "/etc/hosts"         # file
  echo "Exit status is ${?}"
  is_dir "/qwertyasdfgh/jachdffcsda" # Maybe not file
  echo "Exit status is ${?}"
fi
