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

pkg_upgrade() {
  _OS=`checkos -k | tr [:upper:] [:lower:]`
  _DIST=`checkos -d | tr [:upper:] [:lower:]`

  case ${_OS} in
  freebsd)
    sudo pkg upgrade -y
    sudo pkg autoremove -y
  ;;
  linux)
    case "${_DIST}" in
    centos*)
      sudo yum update -y
    ;;
    ubuntu)
      sudo apt upgrade -y
      sudo apt autoremove
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
