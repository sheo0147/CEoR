# Test is exist group
#       written by T.Hayashi, seirios
##############################################################################
# Usage:
# is_exist_group groupname
# RETUEN=`is_exist_group "qwerty"`
# Tested on FreeBSD/CentOS/Ubuntu
#
# Not POSIX Commands: getent

# is_exist_group_TEST=1
# DEBUG=1

is_exist_group() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: is_exist_group: require GROUPNAME"
    return 1
  fi
  local _MSG="exist"
  local _GROUPNAME=${1}
  local _RET=`getent group ${_GROUPNAME}`
  [ ${DEBUG} ] && echo "DEBUG(is_exist_group) ${_GROUPNAME} / RetCode=${_RET}" >&2
  if  [ -z "${_RET}" ] ; then
    echo "Warn group:${_GROUPNAME} is not ${_MSG}"
    return 1
  else
    echo "OK ${_GROUPNAME} is ${_MSG}"
    return 0
  fi
}

##### TEST CODE
if [ ${is_exist_group_TEST} ]; then
  is_exist_group "wheel"         # exist
  echo "Exit status is ${?}"
  is_exist_group "qwertyasdfgh" # Maybe not exist
  echo "Exit status is ${?}"
fi
