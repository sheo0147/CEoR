# add sudo user
#       written by T.Hayashi
##############################################################################
# Usage:
# add_sudo_user username
# RETUEN=`add_sudo_user "username"`
# Tested on CentOS FreeBSD
#
# Not POSIX Commands: 

# add_sudo_user_TEST=1
# DEBUG=1

add_sudo_user() {
  _MODNAME="add_sudo_user"
  [ ${DEBUG} ] && echo "MODULE: ${_MODNAME}"

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
      _SUDOERS_FILE="/usr/local/etc/sudoers"
    ;;
    linux)
      case "${_DIST}" in
        centos* | ubuntu)
          _TARGET="/etc/sudoers.d"
          _SUDOERS_FILE="/etc/sudoers"
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
  [ ${DEBUG} ] && echo "OS: ${_OS}:${_DIST}"
  [ ${DEBUG} ] && echo "target: ${_TARGET}"
# set -x
  [ ! -d ${_TARGET} ] && echo "${_TARGET} is not found. Error exit." && exit 1

  sudo touch ${_TARGET}/${_USERNAME}
  # sudo echo "${_USERNAME} ALL=(ALL) NOPASSWD: ALL" > ${_TARGET}/${_USERNAME}
  _CMD="'${_USERNAME} ALL=(ALL) NOPASSWD: ALL'"
  sudo sh -c "echo ${_CMD} > ${_TARGET}/${_USERNAME}"
  _CMD="'s/^${_USERNAME}/#${_USERNAME}/'"
  sudo sh -c "sed -i -e ${_CMD} ${_SUDOERS_FILE}"

# unset -x

  ##########################################################
  # echo "Not implement yet"
  # return 1
  ##########################################################

}

##### TEST CODE
# if [ ${add_sudo_user_TEST} ]; then
#   # . add_sudo_user.mod
#   # echo "---Add nonexistentuser"
#   # add_sudo_user "nonexistentuser" # Maybe fail
# fi

if [ ${add_sudo_user_TEST} ]; then
  echo "---Add nonexistentuser"
  add_sudo_user "nonexistentuser" # Maybe fail
  echo "Exit status is ${?}"
fi
