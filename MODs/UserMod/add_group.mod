# add group
#       written by T.Hayashi, seirios
##############################################################################
# Usage:
# add_group groupname [gid]
# RETUEN=`add_group "qwerty" 9999`
# Tested on FreeBSD
#
# Not POSIX Commands: pw
# Other MODs: is_exist_group

#add_group_TEST=1
#DEBUG=1

add_group() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: add_group: require GROUPNAME"
    return 1
  fi
  local _GID
  if [ ! -z "${2}" ]; then
    [ "${2}" -eq 0 ] 2> /dev/null
    if [ $? -ge 2 ]; then
      echo >&2 "Error: GID must be a valid integer."
      return 1
    elif [ "${2}" -le 0 ]; then
      echo >&2 "Error: GID must be a positive integer."
      return 1
    else
      [ ${DEBUG} ] && echo "GID: ${2}"
      _GID="-g ${2}"
    fi
  fi
  local _GROUPNAME=${1}
  local _RET
  local _RET_CD
  _RET=`is_exist_group ${_GROUPNAME}`
  _RET_CD=${?}
  if [ ${_RET_CD} -eq 1 ]; then
    _RET=`sudo pw groupadd ${_GROUPNAME} ${_GID}`
    echo "Add group: ${_GROUPNAME}"
  else
    echo "Warning: ${_GROUPNAME} already exist"
  fi
  return 0
}

##### TEST CODE
if [ ${add_group_TEST} ]; then
  . is_exist_group.mod
  echo "---Add qwerty first time"
  add_group "qwerty" # Maybe success
  echo "Exit status is ${?}"
  echo "---Add qwerty second time"
  add_group "qwerty" # already exist
  echo "Exit status is ${?}"
  echo "---Add qwerty2 with invalid GID"
  add_group "qwerty2" qwerty # Fail: GID is invalid
  echo "Exit status is ${?}"
  echo "---Add qwerty2 with negative integer GID"
  add_group "qwerty2" -9999 # Fail: GID is invalid
  echo "Exit status is ${?}"
  echo "---Add qwerty2 with positive integer GID"
  add_group "qwerty2" 9999 # success
  echo "Exit status is ${?}"
fi
