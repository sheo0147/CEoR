# is_time_synced: mod: Investigate Time Syncronized with NTP
#       written by T.Hayashi
##############################################################################
# Usage:
# is_time_synced
# RETUEN=`is_time_synced`
# Tested on centos
#
# Depending Modules : checkos is_exist_command
# Not POSIX Commands: ntpq chronyc
#
# testing flags
# is_time_synced_TEST=1
# DEBUG=0
# 
is_time_synced() {
  # check path
  _DIR="/usr/sbin"
  is_exist_path "${_DIR}"
  if [ ${?} -eq 1 ]; then
    PATH="${PATH}:${_DIR}"
    [ ${DEBUG} ] && echo "DEBUG(is_time_synced) new PATH:${PATH}" >&2
    export PATH
  fi
  __CMD="NOTFOUND"
  is_exist_command "ntpq"
  if [ ${?} -eq 0 ]; then
    __CMD="ntpq"
  else    
    is_exist_command "chronyc"
    if [ ${?} -eq 0 ]; then
      __CMD="chronyc"
    fi    
  fi
  [ ${DEBUG} ] && echo "DEBUG(is_time_synced) found command:${__CMD}" >&2

  case ${__CMD} in
    ntpq)
      _RET=`ntpq -p | grep '^*'`
    ;;
    chronyc)
      _RET=`chronyc sources|grep '^\^\*'`
    ;;
    *)
      echo "ntpq or chronyc command not found."; return 1
  esac
  if [ -z "${_RET}" ]; then
      echo "dont syncronized."; return 1
  else
      echo "time syncronized."; return 0
  fi
}

##### TEST CODE
if [ ${is_time_synced_TEST} ]; then
  :
fi
