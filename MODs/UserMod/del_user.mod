##
## del_user "_USERNAME"
##
#del_user() {
#  if [ -z "${1}" ]; then
#    echo >&2 "Error: del_user: require USERNAME"
#    return 1
#  fi
#  local RET
#  local _USERNAME=${1}
#  RET=`is_exist_user ${_USERNAME}`
#  if [ ${?} -eq 1 ]; then
#    echo "Warn user: ${_USERNAME} not exist"
#    return 0
#  else
#    RET=`sudo pw userdel -n ${_USERNAME} -r`
#    echo "Del user: ${_USERNAME}"
#    return 0
#  fi
#}
#
###### TEST CODE
#if [ ${MOD_TEST} ]; then
#  echo "*****************************************************************************"
#  echo "TEST user add and del(user!=group)"
#  echo "*****************************************************************************"
#  echo "is_exist_user"
#  RET=`is_exist_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "add_user"
#  RET=`add_user -u ${MYUSERNAME} -g ${MYGROUPNAME}`
#  # RET=`add_user -u ${MYUSERNAME} -g`
#  echo "RetCode=${?} / user:group=\"${MYUSERNAME}\":\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "getent"
#  # `getent group ${MYGROUPNAME}`
#  RET=`getent passwd ${MYUSERNAME}`
#  echo ${RET}
#  echo "-----------------------------------------------------------------------------"
#  echo "is_exist_user"
#  RET=`is_exist_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "del_user"
#  RET=`del_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "is_exist_user"
#  RET=`is_exist_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "is_exist_group"
#  RET=`is_exist_group ${MYGROUPNAME}`
#  echo "RetCode=${?} / group=\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "del_group"
#  RET=`del_group ${MYGROUPNAME}`
#  echo "RetCode=${?} / group=\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "is_exist_group"
#  RET=`is_exist_group ${MYGROUPNAME}`
#  echo "RetCode=${?} / group=\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#
#  echo "*****************************************************************************"
#  echo "TEST user add and del(user only)"
#  echo "*****************************************************************************"
#  echo "is_exist_user"
#  RET=`is_exist_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "add_user"
#  RET=`add_user -u ${MYUSERNAME}`
#  # RET=`add_user -u ${MYUSERNAME} -g`
#  echo "RetCode=${?} / user:group=\"${MYUSERNAME}\":\"\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "getent"
#  # `getent group ${MYGROUPNAME}`
#  RET=`getent passwd ${MYUSERNAME}`
#  echo ${RET}
#  echo "-----------------------------------------------------------------------------"
#  echo "getent group"
#  # `getent group ${MYGROUPNAME}`
#  RET=`getent group ${MYUSERNAME}`
#  echo ${RET}
#  echo "-----------------------------------------------------------------------------"
#  echo "is_exist_user"
#  RET=`is_exist_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "del_user"
#  RET=`del_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "is_exist_user"
#  RET=`is_exist_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "getent group"
#  # `getent group ${MYGROUPNAME}`
#  RET=`getent group ${MYUSERNAME}`
#  echo ${RET}
#  echo "-----------------------------------------------------------------------------"
#  echo "is_exist_group"
#  RET=`is_exist_group ${MYUSERNAME}`
#  echo "RetCode=${?} / group=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "del_group"
#  RET=`del_group ${MYUSERNAME}`
#  echo "RetCode=${?} / group=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "is_exist_group"
#  RET=`is_exist_group ${MYUSERNAME}`
#  echo "RetCode=${?} / group=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#
#
#  echo "*****************************************************************************"
#  MYUSERNAME="l-hayashi"
#  MYGROUPNAME="l-hayashi"
#  # echo "user: ${USERNAME}"
#  # echo "user: ${GROUPNAME}"
#  RET=`is_exist_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  RET=`is_exist_group ${MYGROUPNAME}`
#  echo "RetCode=${?} / group=\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "*****************************************************************************"
#  MYUSERNAME="l-hayashixx"
#  MYGROUPNAME="l-hayashixx"
#  # echo "user: ${USERNAME}"
#  # echo "user: ${GROUPNAME}"
#  RET=`is_exist_user ${MYUSERNAME}`
#  echo "RetCode=${?} / user=\"${MYUSERNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  RET=`is_exist_group ${MYGROUPNAME}`
#  echo "RetCode=${?} / group=\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#
#  exit 0
#fi
