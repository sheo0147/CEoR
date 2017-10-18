##
## _is_belonging_group "USERNAME" "GROUPNAME"
##
#is_belonging_group() {
#
#  if [ -z "${1}" ]; then
#    echo >&2 "Error: is_belonging_group: require USERNAME"
#    return 1
#  fi
#  if [ -z "${2}" ]; then
#    echo >&2 "Error: is_belonging_group: require GROUPNAME"
#    return 1
#  fi
#  local USERNAME=${1}
#  local GROUPNAME=${2}
#  local RET=`id ${USERNAME} | awk '{print $3}' | grep ${GROUPNAME}`
#  local RETCD=${?}
#  [ ${DEBUG} ] && echo "DEBUG(is_belonging_group) RetCode=${RETCD} / user:group=\"${USERNAME}\":\"${GROUPNAME}\" / RetString: ${RET}" >&2
#  if [ ${RETCD} -eq 1 ]; then
#    echo "Warn ${USERNAME} is not ${GROUPNAME} user."
#    return 1
#  else
#    echo "is_belonging_group: ${USERNAME} is ${GROUPNAME} user."
#    return 0
#  fi
#}
#
###### TEST CODE
#if [ ${MOD_TEST} ]; then
#  MYUSERNAME="l-hayashi"
#  MYGROUPNAME="wheel"
#  echo "-----------------------------------------------------------------------------"
#  echo "*****************************************************************************"
#  echo "TEST: is_belonging_group"
#  echo "*****************************************************************************"
#  echo "is_belonging_group"
#  RET=`is_belonging_group ${MYUSERNAME} ${MYGROUPNAME}`
#  echo "RetCode=${?} / user:group=\"${MYUSERNAME}\":\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#
#  exit 0
#fi
