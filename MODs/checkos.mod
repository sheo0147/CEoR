# OS checker
#	written by seirios
##############################################################################
# Usage:
# checkos [-a -k -K -d -D -h]
#   -a or none: Output all variables
#   -k        : Kernel
#   -K        : Kernel version
#   -d        : Distribution name
#   -D        : Distribution version
#   -h        : hostname
# RETUEN=`checkos -a`
# Tested on FreeBSD/CentOS/Ubuntu/OS-X

checkos() {
  local _UNAME=`command -v uname`

  [ ${DEBUG} ] && echo "_UNAME=${_UNAME}" >&2

  [ -z ${_UNAME} ] && echo "Error: uname is not exist" && return 1

  local _KERNEL=`${_UNAME} -s`
  local _KERNEL_VERSION=`${_UNAME} -r`
  local _NODENAME=`${_UNAME} -n`
  local _DISTRIB=""
  local _DISTRIB_VERSION=""

  case ${_KERNEL} in
  FreeBSD)
    _DISTRIB=${_KERNEL}
    _DISTRIB_VERSION=`/bin/freebsd-version`
    ;;
  Linux)
    if [ ! -e /etc/os-release ] ; then
      [ ! -e /etc/redhat-release ] && echo "Error: This is Linux but has no os-release" && return 1
      _DISTRIB=`cat /etc/redhat-release | sed -e 's/^\([a-zA-Z][a-zA-Z]*\)..*/\1/'`
      _DISTRIB_VERSION=`cat /etc/redhat-release | sed -e 's/[^0-9.]//g'`
    else
      _DISTRIB=`cat /etc/os-release | sed -ne '/^NAME=/s/.*"\(.*\)"/\1/p'`
      _DISTRIB_VERSION=`cat /etc/os-release | sed -ne '/^VERSION_ID=/s/.*"\(.*\)"/\1/p'`
    fi

    # [ ! -e /etc/os-release ] && echo "Error: This is Linux but has no os-release" && return 1
    # when line matches "^NAME=" output QUOTED string. 
    ;;
  Darwin)
    _DISTRIB=`sw_vers -productName`
    _DISTRIB_VERSION=`sw_vers -productVersion`
  esac

  [ ${DEBUG} ] && echo "node name       : ${_NODENAME}" >&2
  [ ${DEBUG} ] && echo "Kernel          : ${_KERNEL}" >&2
  [ ${DEBUG} ] && echo "Kernel version  : ${_KERNEL_VERSION}" >&2
  [ ${DEBUG} ] && echo "Distrib         : ${_DISTRIB}" >&2
  [ ${DEBUG} ] && echo "Distrib version : ${_DISTRIB_VERSION}" >&2

  [ ${#} -eq 0 ] && echo "${_NODENAME} ${_KERNEL} ${_KERNEL_VERSION} ${_DISTRIB} ${_DISTRIB_VERSION}" && return 0
  case ${1} in
  -k) echo "${_KERNEL}"; return 0 ;;
  -K) echo "${_KERNEL_VERSION}"; return 0 ;;
  -d) echo "${_DISTRIB}"; return 0 ;;
  -D) echo "${_DISTRIB_VERSION}"; return 0 ;;
  -h) echo "${_NODENAME}"; return 0 ;;
  -a) echo "${_NODENAME} ${_KERNEL} ${_KERNEL_VERSION} ${_DISTRIB} ${_DISTRIB_VERSION}"; return 0 ;;
  *)  echo "Option Error"; return 1 ;;
  esac
}

##### TEST CODE
if [ ${checkos_TEST} ]; then
  for OPT in "  " "-k" "-K" "-d" "-D" "-h" "-a" "- "; do
    RET=`checkos ${OPT}`
    echo "RetCode=${?} / Opt=\"${OPT}\" / RetString: ${RET}"
    echo
  done
fi
