# is_exist_file_or_dir: mod:File exist testing
#       written by T.Hayashi
##############################################################################
# Usage:
# is_exist_file_or_dir
# RETUEN=`is_exist_file_or_dir  "any_file_or_dir"`
# Tested on FreeBSD
#
# Not POSIX Commands:
#
# testing flags
is_exist_file_or_dir_TEST=1
# DEBUG=0

is_exist_file_or_dir() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: is_exist_file_or_dir: require filename|directoryname"
    return 1
  fi
  local _MSG="exist"
  local _FILENAME=${1}

   [ ${DEBUG} ] && echo "DEBUG(is_exist_file_or_dir) file_or_dir_name:${1}" >&2
  if [ ! -e "${_FILENAME}" ]; then
    echo "Warn ${_FILENAME} is not ${_MSG}"
    return 1
  else
    echo "OK ${_FILENAME} is ${_MSG}"
    return 0
  fi
}

##### TEST CODE
if [ ${is_exist_file_or_dir_TEST} ]; then
  is_exist_file_or_dir "/etc/hosts"         # exist file
  echo "Exit status is ${?}"
  is_exist_file_or_dir "/etc"         # exist file
  echo "Exit status is ${?}"
  is_exist_file_or_dir "/qwertyasdfgh/jachdffcsda" # Maybe not exist
  echo "Exit status is ${?}"
fi
