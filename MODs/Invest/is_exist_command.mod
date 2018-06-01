# is_exist_command: mod:command exist testing
#       written by T.Hayashi
##############################################################################
# Usage:
# is_exist_command
# RETUEN=`is_exist_command  "any_command"`
# Tested on Ubuntu@WSL
#
# Not POSIX Commands:
#
# testing flags
is_exist_command_TEST=1
# DEBUG=0

is_exist_command() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: is_exist_command: require command name"
    return 1
  fi
  local _MSG="exist"
  local _CMDNAME=${1}
  local _CMD=`which ${_CMDNAME}`

   [ ${DEBUG} ] && echo "DEBUG(is_exist_command) command:${1}" >&2
  if [ -z "${_CMD}" ]; then
    echo "Warn ${_CMDNAME} is not ${_MSG}"
    return 1
  else
    echo "OK ${_CMDNAME} is ${_MSG} on ${_CMD}"
    return 0
  fi
}

##### TEST CODE
if [ ${is_exist_command_TEST} ]; then
  is_exist_command "ls"         # exist
  echo "Exit status is ${?}"
  is_exist_command "whoami"         # exist
  echo "Exit status is ${?}"
  is_exist_command "alxachdffcsda" # Maybe not exist
  echo "Exit status is ${?}"
fi
