#! /bin/sh -f
#
# Title:
#  ceor.sh
#  CEoR (Command Executer on Remote)
#
# for /usr/bin/what:
#  @(#) ceor.sh : Command Executer on Remote Main file
#

##############################################################################
#
# Copyright (c) 2017- HEO SeonMeyong.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, 
#    this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

## Argument Parse
while getopts "h:u:" __FLAG; do
  case "${__FLAG}" in
  h)
    __TGT="${OPTARG}"
  ;;
  u)
    __RUSR="${OPTARG}@"
  ;;
  esac
done
unset __FLAG
shift $(( ${OPTIND} - 1 ))
__RECIPE="${@}"

if [ -z "${__TGT}" -o -z "${__RECIPE}" ]; then
  echo >&2 "Usage: $0 -h Target [-u user] receipe"
  exit 1
fi
export __RUSR __TGT

## Read Configurations
[ -r ./ceor.conf.local ] && . ./ceor.conf.local
if [ -z "${CEoRETC}" ]; then
  [ -r /usr/local/etc/ceor.conf ] && . /usr/local/etc/ceor.conf
  [ -r ./ceor.conf ] && . ./ceor.conf
else
  [ -r ${CEoRETC}/ceor.conf ] && . ${CEoRETC}/ceor.conf
  [ -r /usr/local/etc/ceor.conf ] && . /usr/local/etc/ceor.conf
  [ -r ./ceor.conf ] && . ./ceor.conf
fi

if [ ${DEBUG} -ne 0 ]; then
  #>&2 echo "DEBUG: CEoRETC=${CEoRETC}"
  #>&2 echo "DEBUG: CEoRGENINC=${CEoRGENINC}"
  [ ${CEoR_CONF_READ} -ne 1 ] && echo "DEBUG: not readed ceor.conf"
fi

##### Check Receipes #########################################################
__ERROR=0
for __i in ${__RECIPE}; do
  if [ ! -e "${__i}" ]; then
    echo "Error ${__i} is not exist"
    __ERROR=1
  fi
done

if [ ${__ERROR} -ne 0 ]; then
  exit 1
fi
unset __ERROR

##### Generate Scripts #######################################################
atexit() {
  [ ! -z "${__TMPDIR}" ] && rm -rf "${__TMPDIR}"
}
trap atexit EXIT
trap 'trap - EXIT; atexit; exit -1' INT PIPE TERM

__TMPDIR=$(mktemp -d ./.CEoR.XXXXXX)
export __TMPDIR

cat << "__END__" >> ${__TMPDIR}/module.sh
__SUDO=`which sudo`
[ -z "${__SUDO}" ] && echo "Do not have sudo!. exit" && exit 1
__END__

for __i in ${CEoRGENINC} ${CEoRLOCINC} ${CEoRPRJINC}; do
  if [ -d ${__i} ]; then
    for __j in $(find ${__i} -type f); do
      echo "##### from ${__j}" >> ${__TMPDIR}/module.sh
      cat ${__j} | sed -e '/^[     ]*#/d' >> ${__TMPDIR}/module.sh
    done
  fi
done

#------------------------------------------------------------
#for __i in ${__RECIPE}; do
#  echo "##### from ${__i}" >> ${__TMPDIR}/remote.sh
#  cat ${__i} | sed -e '/^[     ]*#/d' >> ${__TMPDIR}/remote.sh
#done
#
#if [ ${DEBUG} -ne 0 ]; then
#  cp ${__TMPDIR}/remote.sh .
#fi
#------------------------------------------------------------

##### Execute Scripts ########################################################
__SSH_OPT="-o ControlMaster=auto -o ControlPath=${__TMPDIR}/ssh-${__TGT} -o ForwardX11=no"
/usr/bin/ssh -N -f ${__SSH_OPT} ${__RUSR}${__TGT}
export __SSH_OPT

for __i in ${__RECIPE}; do
  __TGT_SCRDIR=`ssh ${__SSH_OPT} -q ${__RUSR}${__TGT} mktemp -d .CEoR.XXXXXX`
  export __TGT_SCRDIR

  cp ${__i} ${__TMPDIR}/recipe.sh
  cat << "__END__" >> ${__TMPDIR}/recipe.sh
# execute
${1}
__END__

  /bin/sh ${__TMPDIR}/recipe.sh prepare
  [ ${?} -ne 0 ] && echo "Error in prepare. Exit" && exit

  echo "#!/bin/sh" > ${__TMPDIR}/remote.sh
  # Export environment variables
  echo "__TGT_SCRDIR=${__TGT_SCRDIR}" >> ${__TMPDIR}/remote.sh
  echo "__TGT=${__TGT}" >> ${__TMPDIR}/remote.sh
  # Generate script
  cat ${__TMPDIR}/module.sh >> ${__TMPDIR}/remote.sh
  cat ${__TMPDIR}/recipe.sh | sed -e '/^[     ]*#/d' >> ${__TMPDIR}/remote.sh
  scp ${__SSH_OPT} -q -rp ${__TMPDIR}/remote.sh "${__RUSR}${__TGT}:${__TGT_SCRDIR}"
  ssh ${__SSH_OPT} -q -t "${__RUSR}${__TGT}" "/bin/sh ${__TGT_SCRDIR}/remote.sh main"
  __ERROR=${?}
  [ ${DEBUG} -ne 0 ] && cp ${__TMPDIR}/remote.sh .
  rm ${__TMPDIR}/remote.sh
  ssh ${__SSH_OPT} -q -t "${__RUSR}${__TGT}" "rm ${__TGT_SCRDIR}/remote.sh"
  [ ${__ERROR} -ne 0 ] && echo "Error in main. Exit" && exit

  /bin/sh ${__TMPDIR}/recipe.sh afterwords

  ssh ${__SSH_OPT} -q "${__RUSR}${__TGT}" "/bin/rm -rf ${__TGT_SCRDIR}"
done
/usr/bin/ssh -O exit ${__SSH_OPT} ${__RUSR}${__TGT}
