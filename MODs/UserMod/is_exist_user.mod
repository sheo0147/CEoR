# Test is exist user
#       written by T.Hayashi, seirios
##############################################################################
# Usage:
# is_exist_user username
# RETUEN=`is_exist_user "seirios"`
# Tested on FreeBSD
#
# Not POSIX Commands: getent

# is_exist_user_TEST=1
# DEBUG=1

is_exist_user() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: is_exist_user: require username"
    return 1
  fi
  _MSG="exist"
  _RET=`getent passwd ${1}`
  [ ${DEBUG} ] && echo "DEBUG(is_exist_user) ${1}:${_RET}" >&2

  if  [ -z "${_RET}" ] ; then
    echo "Warn user: ${1} is not ${_MSG}"
    return 1
  else
    echo "OK ${1} is ${_MSG}"
    return 0
  fi
}

##### TEST CODE
if [ ${is_exist_user_TEST} ]; then
  is_exist_user "root"         # exist
  echo "Exit status is ${?}"
  is_exist_user "qwertyasdfgh" # Maybe not exist
  echo "Exit status is ${?}"
fi
