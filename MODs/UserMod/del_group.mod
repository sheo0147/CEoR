# delete group
#       written by T.Hayashi, seirios
##############################################################################
# Usage:
# del_group groupname
# RETUEN=`del_group "qwerty"`
# Tested on FreeBSD
#
# Not POSIX Commands: pw

# del_group_TEST=1
# DEBUG=1

del_group() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: del_group: require GROUPNAME"
    return 1
  fi
  _GROUPNAME=${1}
  _RET=`is_exist_group ${_GROUPNAME}`
  if [ ${?} -eq 1 ]; then
    echo "Warn ${_GROUPNAME} not exist"
    return 0
  else
    _RET=`sudo pw groupdel -n ${_GROUPNAME}`
    echo "Del group: ${_GROUPNAME}"
    return 0
  fi
}

##### TEST CODE
if [ ${del_group_TEST} ]; then
  . is_exist_group.mod
  del_group "qwerty" # Maybe success when after add_group
  echo "Exit status is ${?}"
  del_group "qwerty" # already exist
  echo "Exit status is ${?}"
fi
