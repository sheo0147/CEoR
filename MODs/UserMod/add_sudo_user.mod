# add sudo user
#       written by T.Hayashi
##############################################################################
# Usage:
# add_sudo_user username
# RETUEN=`add_sudo_user "username"`
# Tested on 
#
# Not POSIX Commands: 

# add_sudo_user_TEST=1
# DEBUG=1

add_sudo_user() {
  _MODNAME="add_sudo_user"
  if [ -z "${1}" ]; then
    echo >&2 "Error: ${_MODNAME}: require USERNAME"
    return 1
  fi
  _USERNAME=${1}

  _RET=`is_exist_user ${_USERNAME}`
  _RET_CD=${?}
  if [ ${_RET_CD} -eq 1 ]; then
    echo >&2 "Error: ${_MODNAME}: ${_USERNAME} not found"
    return 1
  fi
  _OS=`checkos -k | tr [:upper:] [:lower:]`
  _DIST=`checkos -d | tr [:upper:] [:lower:]`

  case "${_OS}" in
    freebsd)
      _TARGET="/usr/local/etc/sudoers.d"
    ;;
    linux)
      _TARGET="/etc/sudoers.d"
      case "${_DIST}" in
        centos*)
        ;;
        ubuntu)
        ;;
        *)
          echo "Not Supported Distribution" >&2
          exit 1
        ;;
      esac
    ;;
    *)
      echo "Not Supported Platform" >&2
      exit 1
    ;;
  esac

  # [ ! -d ${_TARGET} ] && echo "${_TARGET} is not found. Error exit." && exit 1

 
  ##########################################################
  echo "Not implement yet"
  return 1
  ##########################################################

}
##### TEST CODE
if [ ${add_sudo_user_TEST} ]; then
  # . add_sudo_user.mod
  # echo "---Add nonexistentuser"
  # add_sudo_user "nonexistentuser" # Maybe fail
fi
