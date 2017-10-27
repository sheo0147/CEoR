# pkg_list.mod: get list of installed packages.
#	written by seirios
##############################################################################
# Usage:
# pkg_list
# RETUEN=`pkg_list`
# Tested on FreeBSD/CentOS/Ubuntu
#
# Not POSIX Commands: 
# Other MODs: checkos

pkg_update() {
  _OS=`checkos -k | tr [:upper:] [:lower:]`
  _DIST=`checkos -d | tr [:upper:] [:lower:]`

  case ${_OS} in
  freebsd)
    sudo pkg update
  ;;
  linux)
    case "${_DIST}" in
    centos*)
      sudo yum check-update
    ;;
    ubuntu)
      sudo apt update
    ;;
    esac
  ;;
  *)
    echo "Not supported platform."; return 1
  esac

}

##### TEST CODE
if [ ${pkg_list_TEST} ]; then
  . ../checkos.mod
  echo "Before"
  RET=`pkg_list`
  echo "TEST:pkg_list: ${RET}"
  echo "after"
  echo
fi
