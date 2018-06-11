# is_file: mod:this is file
#       written by T.Hayashi
##############################################################################
# Usage:
# is_file
# RETUEN=`is_file  "any_file"`
# Tested on FreeBSD
#
# Not POSIX Commands:
#
# testing flags
# is_file_TEST=1
# DEBUG=0

is_file() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: is_file: require filename"
    return 1
  fi
  local _MSG="file"
  local _FILENAME=${1}

   [ ${DEBUG} ] && echo "DEBUG(is_file) filename:${1}" >&2
  if [ ! -f "${_FILENAME}" ]; then
    echo "Warn ${_FILENAME} is not ${_MSG}"
    return 1
  else
    echo "OK ${_FILENAME} is ${_MSG}"
    return 0
  fi
}

##### TEST CODE
if [ ${is_file_TEST} ]; then
  is_file "/etc/hosts"         # file
  echo "Exit status is ${?}"
  is_file "/etc"         # not file
  echo "Exit status is ${?}"
  is_file "/qwertyasdfgh/jachdffcsda" # Maybe not file
  echo "Exit status is ${?}"
fi
