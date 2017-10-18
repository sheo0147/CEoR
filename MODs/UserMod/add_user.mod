##
## add_user -u "USERNAME" [-g "GROUPNAME"] [-m]
##
#add_user() {
#  local _OPT
#  local _USERNAME
#  local _GROUPNAME
#  local _OPT_MKHOME=0
#  local _OPT_ERROR=0
#  local RET
#
#  [ ${DEBUG} ] && echo "DEBUG(add_user) ${@}" >&2
#
#  while getopts "u:g:m" _OPT; do
#    case $_OPT in
#      u) _USERNAME="$OPTARG";;
#      g) _GROUPNAME="$OPTARG";;
#      m) _OPT_MKHOME=1;;
#      \?) _OPT_ERROR=1
#          echo >&2 "Error: add_user: Illegal option"
#          return 1;;
#    esac
#  done
#
#  [ ${DEBUG} ] && echo "DEBUG(add_user) USERNAME=${_USERNAME}" >&2
#  [ ${DEBUG} ] && echo "DEBUG(add_user) GROUPNAME=${_GROUPNAME}" >&2
#
#  if [ -z "${_GROUPNAME}" ]; then
#    _GROUPNAME="${_USERNAME}"
#  fi
#
#  [ ${DEBUG} ] && echo "DEBUG(add_user) 30" >&2
#  RET=`add_group "${_GROUPNAME}"`
#  local _RET_CD=${?}
#  [ ${DEBUG} ] && echo "DEBUG(add_user) 40" >&2
#  [ ${DEBUG} ] && echo "DEBUG(add_user->add_group) RetCode=${_RET_CD} / RetString: ${RET}" >&2
#
#  if [ ${_RET_CD} -eq 1 ]; then
#    return 1
#  else
#    [ ${DEBUG} ] && echo "DEBUG(add_user) Add GROUP=${_GROUPNAME}: ret str=${RET}" >&2
#  fi
#
#  RET=`is_exist_user ${_USERNAME}`
#  if [ ${?} -eq 0 ]; then
#    echo >&2 "Error: add_user: ${_USERNAME} already exist"
#    return 1
#  else
#    RET=`sudo pw useradd -n ${_USERNAME} -g ${_GROUPNAME} -m -c ${_USERNAME} `
#    echo "Add user: ${_USERNAME}"
#    return 0
#  fi
#
#  # ##########################################################
#  # echo "Not implement yet"
#  # return 1
#  # ##########################################################
#
#}
#
###### TEST CODE
#if [ ${MOD_TEST} ]; then
#  echo "*****************************************************************************"
#  echo "TEST: add user option parameter not found"
#  echo "*****************************************************************************"
#  echo "add_user"
#  RET=`add_user -u ${MYUSERNAME} -g`
#  echo "RetCode=${?} / user:group=\"${MYUSERNAME}\":\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#  echo "*****************************************************************************"
#  echo "TEST: add user illegal option"
#  echo "*****************************************************************************"
#  echo "add_user"
#  RET=`add_user -u ${MYUSERNAME} -z`
#  echo "RetCode=${?} / user:group=\"${MYUSERNAME}\":\"${MYGROUPNAME}\" / RetString: ${RET}"
#  echo "-----------------------------------------------------------------------------"
#
#
#
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
