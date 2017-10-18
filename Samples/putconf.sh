#! /bin/sh

if [ ${#} -eq 0 ]; then
  echo "Error. must specify target node."
  exit 1
else
  _TGT=${@}
fi

for i in ${_TGT} ; do
  echo "::::: ${i} :::::"
  /bin/sh ceor.sh  -h $i -u adm RCPs/putconf.rcp
done
