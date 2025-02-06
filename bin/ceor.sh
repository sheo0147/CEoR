#! /bin/sh -f
#
#  ceor.sh		: CEoR (Command Executer on Remote)
#
# for /usr/bin/what:
#  @(#) ceor.sh : Command Executer on Remote Main file
#

##############################################################################
#
# Copyright (c) 2018- HEO SeonMeyong.
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

# Global Variables
: ${__EXPORT_ENV_NAME:=""}
: ${__CONFENV_O:=""}			# User defined Path Env-Val List
: ${__CONFENV_P:=""}			# User defined Other Env-Val List
: ${__CONFDIR:="/usr/local/CEoR/etc"}	# Default configuration file.
: ${__CONFFILE:="ceor.conf"}	# Default configuration file.


##############################################################################
# Functions.
##############################################################################
echo () {
  # Overwrite built-in echo so that it can't takes any options/operands
  printf "%s\n" "$*"
}
##############################################################################
parse_conf() {			# parse configuration files.

  # Define Variables.
  S=1					# temporaly Suffix
  E="" V="" T="" L="" M=""		# temporaly Variables
  i=0 j=0					# loop counter

  # Read configuration file and normalize Variables_name and Values.
  for i in ${*}; do
    if [ ! -r "${i}/${__CONFFILE}" ]; then
       echo "Warning: ${i}/${__CONFFILE} is not found"
       continue
    fi
    while read -r j; do
      L=$(echo "${j%%#*}" | sed -e 's/^[[:space:]]*$//')  # Remove comment line.
      [ -z "${L}" ] && continue

      [ -z "${M}" ] && [ ${L%%[!\[]*} != '[' ] && echo "parse_conf: Error! : Syntax is error in ${i}/${__CONFFILE}" && exit 1
      # Check and set mode.
      if [ "${L%%[!\[]*}" = '[' ]; then
        V="${L#*\[}"
	V="${V%\]*}"
	V=$(echo "${V}" | tr "[:lower:]" "[:upper:]")
        [ ! -z "${V}" ] && [ "${V}" != "PATH" ] && [ "${V}" != "OTHER" ] && echo "parse_conf: Error! : Syntax error in ${i}/${__CONFFILE}" && exit 1
        M="${V}"
        continue
      fi

      # normalize ENV NAME to UPPER case, and space(separator) remove
      E=$(echo "${L%%:*}" | tr -d "[:space:]" | tr "[:lower:]" "[:upper:]")
      # Escape ENV variables if Value has ENV variables, 
      V=$(echo "${L#*:}" | sed 's/[$]/\\$/g;s/^[ ]*//;s/[ ]*$//')
      T="${E}_${S}"
      eval "${T}"="${V}"
      if [ "${M}" = "PATH" ]; then
        __CONFENV_P="${__CONFENV_P} ${E}"
      elif [ "${M}" = "OTHER" ]; then
        __CONFENV_O="${__CONFENV_O} ${E}"
      fi
    done < "${i}/${__CONFFILE}"
    S=$(( ${S} + 1 ))
    M=""
  done

  # uniq values without sort.
  __CONFENV_P=$(for i in ${__CONFENV_P}; do echo "${i}"; done | awk '!tmp[$0]++')
  __CONFENV_O=$(for i in ${__CONFENV_O}; do echo "${i}"; done | awk '!tmp[$0]++')

  # Concat PATH ENV
  for i in ${__CONFENV_P}; do
    T="" j=1
    while [ ${j} -ne ${S} ]; do
      T="${T}:$(eval echo '${'$(eval echo ${i}_${j})'}')"
      unset "$(eval echo ${i}_${j})"
      j=$(( ${j} + 1 ))
    done
    T=$(echo "${T}" | sed 's/::*/:/g;s/^://;s/:$//' | tr ":" " ")
    # uniq values without sort
    T=$(for j in ${T}; do echo "${j}"; done | awk '!tmp[$0]++')
    eval "${i}=\"${T}\""
  done

  # Overwrite OTHER ENV
  for i in ${__CONFENV_O}; do
    T="" TT="" j=${S}
    until [ ${j} -le 1 ]; do
      j=$(( ${j} - 1 ))
      TT="$(eval echo '${'$(eval echo ${i}_${j})'}')"
      [ -z "${TT}" ] && continue
      unset "$(eval echo ${i}_${j})"
      T=${TT}
    done
    T=$(echo "${T}" | sed 's/::*/:/g;s/^://;s/:$//' | tr ":" " ")
    # uniq values without sort
    T=$(for j in ${T}; do echo "${j}"; done | awk '!tmp[$0]++')
    eval "export ${i}=\"${T}\""
  done
}

##############################################################################
display_envlist(){		# display envlists
  for i in ${__CONFENV_P} ${__CONFENV_O}; do
    echo "${i}=\"$(eval echo '${'$(eval echo ${i})'}')\""
  done
}
##############################################################################
check_file_in_path_env(){	# check file exist in ENVNAME path
# ${1} : search filename	ex: getconf, adduser...
# ${2} : ENVname.		ex: RECIPE, MODULE...
# Return first match filename.
# 	ex.:	RET=check_file_in_path_env "FileName" "RECIPE"

  loop="$(eval echo '${'$(eval echo ${2})"}")"
  if [ -z "${loop}" ]; then
    echo "check_file_in_path_env: Error: PATH Environment(${2}) is not available" 1>&2
    return 2
  fi
  [ -e ${1} ] && echo "${1}" && return 0
  for i in ${loop}; do
    i=$(echo $i | sed 's/\/$//')
    [ -e ${i}/${1} ] && echo "${i}/${1}" && return 0
  done
  echo "" && return 1
}

##############################################################################
####### MAIN ROUTINE...
##############################################################################

# Initialize EnvVal
__LOCALRUN=0

# Parse arguments.
while getopts d:f:h:lu: __FLAG; do
  case "${__FLAG}" in
  d) # Config Dirs
    __CONFDIR="${OPTARG}"
  ;;
  f) # RCP Filename
    __CONFFILE="${OPTARG}"
  ;;
  h) # Target node
    __TGT="${OPTARG}"
  ;;
  l) # Run locally
    __LOCALRUN=1
  ;;
  u) # Run by user
    __RUSR="${OPTARG}"
  ;;
  *)
    echo "${0}: Error : Invalid argument."
    exit 1
  ;;
  esac
done
unset __FLAG
shift $(( ${OPTIND} - 1 ))
__RECIPE="${*}"

if [ -z "${__TGT}" ] || [ -z "${__RECIPE}" ]; then
  echo >&2 "Usage: $0 -h Target [-u user] receipes"
  exit 1
fi
__EXPORT_ENV_NAME="${__EXPORT_ENV_NAME} __RUSR __TGT"

##### CEoR initialize.
# Read configuration file
parse_conf ${__CONFDIR}
# Re-read all configuration file
parse_conf "${CONFS}"

# Check recipe.
for i in ${__RECIPE}; do
  __RCP="${__RCP} $(check_file_in_path_env ${i} \"RECIPE\")"
  [ $? -ne 0 ] && echo "ceor: Error: ${i} is not found" && exit 1
done
__RECIPE="${__RCP}"

##### Generate Scripts #######################################################
atexit() {
  if [ -e ${__TMPDIR}/ssh-${__TGT} ]; then
    /usr/bin/ssh ${__SSH_OPT} -q ${__RUSR_OPT} "${__TGT}" "/bin/rm -rf ${__TGT_SCRDIR}"
    /usr/bin/ssh -O exit ${__SSH_OPT} ${__RUSR_OPT} ${__TGT}
  fi
  [ ! -z "${__TMPDIR}" ] && rm -rf "${__TMPDIR}"
}
trap atexit EXIT
trap 'trap - EXIT; atexit; exit -1' INT PIPE TERM

__TMPDIR=$(mktemp -d ./.CEoR.XXXXXX)
__EXPORT_ENV_NAME="${__EXPORT_ENV_NAME} __TMPDIR"

#####

cat << "__END__" >> ${__TMPDIR}/module.sh
__SUDO=`command -v sudo`
[ -z "${__SUDO}" ] && echo "Do not have sudo!. exit" && exit 1
__END__

for __i in ${MODULE}; do
  if [ -d ${__i} ]; then
    for __j in $(find ${__i} -type f -name '*.mod'); do
      echo "##### from ${__j}" >> ${__TMPDIR}/module.sh
      cat ${__j} | sed -e '/^[[:space:]]*#/d' >> ${__TMPDIR}/module.sh
    done
  fi
done

##### Execute Scripts ########################################################
__SSH_OPT="-o ControlMaster=auto -o ControlPath=${__TMPDIR}/ssh-${__TGT} -o ControlPersist=10m -o ForwardX11=no"
[ ! -z "${SSH_CONFIG}" ] && [ -e "${SSH_CONFIG}" ] && __SSH_OPT="-F ${SSH_CONFIG} ${__SSH_OPT}"
[ ! -z ${__RUSR} ] && __RUSR_OPT="-l ${__RUSR}"
/usr/bin/ssh -N -f ${__SSH_OPT} ${__RUSR_OPT} ${__TGT}
__EXPORT_ENV_NAME="${__EXPORT_ENV_NAME} __SSH_OPT"
eval "export ${__EXPORT_ENV_NAME}"

##### Execute Recipes
for __i in ${__RECIPE}; do
  __TGT_SCRDIR=`ssh ${__SSH_OPT} ${__RUSR_OPT} -q ${__TGT} mktemp -d .CEoR.XXXXXX`
  export __TGT_SCRDIR

  cp ${__i} ${__TMPDIR}/recipe.sh
  cat << "__END__" >> ${__TMPDIR}/recipe.sh
# execute
${1}
__END__

  #----- Exec prepare() -----
  echo "#!/bin/sh" > ${__TMPDIR}/local.sh
  cat ${__TMPDIR}/module.sh >> ${__TMPDIR}/local.sh
  cat ${__TMPDIR}/recipe.sh | sed -e '/^[[:space:]]*#/d' >> ${__TMPDIR}/local.sh
  /bin/sh ${__TMPDIR}/local.sh prepare
  [ ${?} -ne 0 ] && echo "Error in prepare. Exit" && exit

  #----- Execute remote -----
  echo "#!/bin/sh" > ${__TMPDIR}/remote.sh
  # Export environment variables
  echo "__TGT_SCRDIR=${__TGT_SCRDIR}" >> ${__TMPDIR}/remote.sh
  echo "__TGT=${__TGT}" >> ${__TMPDIR}/remote.sh
  # Generate script
  cat ${__TMPDIR}/local.sh >> ${__TMPDIR}/remote.sh
if [ ${__LOCALRUN} -eq 0 ]; then
  scp ${__SSH_OPT} -q -rp ${__TMPDIR}/remote.sh "${__RUSR}@${__TGT}:${__TGT_SCRDIR}"
  ssh ${__SSH_OPT} -q ${__RUSR_OPT} -t "${__TGT}" "/bin/sh ${__TGT_SCRDIR}/remote.sh main"
else
  sudo -u ${__RUSR} -i /bin/sh ${__TMPDIR}/remote.sh main
fi
  __ERROR=${?}
  rm ${__TMPDIR}/remote.sh
  ssh ${__SSH_OPT} -q ${__RUSR_OPT} -t "${__TGT}" "rm ${__TGT_SCRDIR}/remote.sh"
  [ ${__ERROR} -ne 0 ] && echo "Error in main. Exit" && exit

  #----- Exec afterwords -----
  /bin/sh ${__TMPDIR}/local.sh afterwords
  ssh ${__SSH_OPT} -q ${__RUSR_OPT} "${__TGT}" "/bin/rm -rf ${__TGT_SCRDIR}"
done

/usr/bin/ssh -O exit ${__SSH_OPT} ${__RUSR_OPT} ${__TGT}
