# parse_ini: parse ini file
#       written by ??
##############################################################################
# Usage:
# parse_ini
# . parse_ini "section_name" ["inifile_name"] 
# Tested on Ubuntu@WSL and FreeBSD
#
# Not POSIX Commands:
#
# testing flags
# parse_ini_TEST=1
# DEBUG=1

parse_ini() {
  if [ -z "${1}" ]; then
    echo >&2 "Error: parse_ini: require section_name"
    return 1
  fi
  # setting
  _INI_SECTION=${1}
  if [ -z ${2} ]; then
    _INI_FILE="./CEoR.ini"
  else
    _INI_FILE=${2}
  fi

  [ ${DEBUG} ] && echo "DEBUG(parse_ini) _INI_SECTION:${_INI_SECTION}" >&2
  [ ${DEBUG} ] && echo "DEBUG(parse_ini) _INI_FILE:${_INI_FILE}" >&2

  # ini parse
  eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
    -e 's/;.*$//' \
    -e 's/[[:space:]]*$//' \
    -e 's/^[[:space:]]*//' \
    -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
    < ${_INI_FILE} \
    | sed -n -e "/^\[${_INI_SECTION}\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

  return 0
}

##### TEST CODE
if [ ${parse_ini_TEST} ]; then
  parse_ini "sectionA" "test_parse_ini.ini"
  echo ${KEY1}                        # 123
  echo "Exit status is ${?}"
  parse_ini "sectionB" "test_parse_ini.ini"
  echo ${KEY2}                        # DEF
  echo "Exit status is ${?}"
  parse_ini "sample" "test_parse_ini.ini"
  echo ${HOST}                        # foobar.com
  echo ${IP}                          # 10.10.10.10
  echo ${KEY3}                        # not assign
  echo ${KEY2}                        # Side effects
fi

