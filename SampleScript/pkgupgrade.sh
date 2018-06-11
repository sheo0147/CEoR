#! /bin/sh

if [ ${#} -eq 0 ]; then
  . nodelist.sh
  _TGT=${ALL_TARGET}
else
  _TGT=${@}
fi

for i in ${_TGT} ; do
  echo "::::: ${i} :::::"
  /bin/sh /usr/local/CEoR/bin/ceor.sh  -h $i -u idempotence pkgupdate.rcp pkgupgrade.rcp
done
