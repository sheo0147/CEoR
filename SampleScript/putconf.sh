#! /bin/sh

if [ ${#} -eq 0 ]; then
  echo "Error. must specify target node."
  exit 1
else
  _TGT=${@}
fi

for i in ${_TGT} ; do
  echo "::::: ${i} :::::"
  /bin/sh /usr/local/CEoR/bin/ceor.sh  -h $i -u idempotence putconf.rcp
done
