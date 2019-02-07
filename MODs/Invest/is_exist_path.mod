# is_exist_path: mod: Investigate specified DIR exists in the PATH
#       written by T.Hayashi
##############################################################################
# Usage:
# is_exist_path
# RETUEN=`is_exist_path "/usr/loca/sbin"`
# Tested on centos
#
# Depending Modules : 
# Not POSIX Commands: 
#
# testing flags
# is_exist_path_TEST=1
# DEBUG=0
# 
is_exist_path() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: is_exist_path: require investigate dir name"
    return 1
  fi
  _DIR=${1}
  _RET=`echo "${PATH}"|grep "${_DIR}"`
  if [ -z "${_RET}" ]; then
      echo "${_DIR} not exists in the PATH."; return 1
  else
      return 0
  fi

}

##### TEST CODE
if [ ${is_exist_path_TEST} ]; then
  is_exist_path "/bin"         # exist
  echo "Exit status is ${?}"
  is_exist_path "/xbin"         # maybe not exist
  echo "Exit status is ${?}"

fi
