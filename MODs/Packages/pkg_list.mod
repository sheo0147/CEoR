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

pkg_list() {
  _OS=`checkos -k | tr [:upper:] [:lower:]`
  _DIST=`checkos -d | tr [:upper:] [:lower:]`

  case ${_OS} in
  FreeBSD)
    pkg info -a
  ;;
  Linux)
    case "${_DIST}" in
    centos*)
      sudo yum list installed
    ;;
    utuntu)
      sudo apt list --installed
    ;;
    esac
  ;;
  *)
    echo "Not supported platform."; return 1
  esac

}

##### TEST CODE
if [ ${pkg_list_TEST} ]; then
    RET=`pkg_list`
    echo "TEST:pkg_list: ${RET}"
    echo
  done
fi
