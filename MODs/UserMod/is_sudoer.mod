#
# is_sudoer
#
# Test is sudoer user
#       written by T.Hayashi
##############################################################################
# Usage:
#   is_sudoer
#   RETUEN=`is_sudoer`
# 
# Tested on CentOS,FreeBSD
#
# Not POSIX Commands: 
# 
is_sudoer() {
 local SUDO=`which sudo`
 [ ${DEBUG} ] && echo "DEBUG(is_sudoer) sudo=${SUDO}" >&2
 [ -z ${SUDO} ] && echo >&2 "Error: sudo is not exist" && return 1

 local RET=`echo ""|sudo -S whoami`
 local RETCD=${?}
 [ ${DEBUG} ] && echo "DEBUG(is_sudoer) \"sudo -S whoami\" RetCode=${RETCD} / RetString: ${RET}" >&2
 if [ -z ${RET} ]; then
   echo "not root"
   return 1
 else
   echo "${RET}"
   return 0
 fi

}


##### TEST CODE
if [ ${is_sudoerTEST} ]; then
 echo "-----------------------------------------------------------------------------"
 echo "*****************************************************************************"
 echo "TEST: is_sudoer"
 echo "*****************************************************************************"
 echo "is_sudoer"
 RET=`is_sudoer`
 echo "RetCode=${?} / RetString: ${RET}"
 echo "-----------------------------------------------------------------------------"
 exit 0
fi
