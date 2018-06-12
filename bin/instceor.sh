#!/bin/sh
##############################################################################
#
#  instceor.sh		: Install CEoR to /usr/local/CEoR
#
# for /usr/bin/what:
#  @(#) instceor.sh : Install CEoR to /usr/local/CEoR
#
##############################################################################

[ $(id -u) -ne 0 ] && echo "Error: Need root permission." && exit 1

echo "Install CEoR to /usr/local/CEoR"
for i in /usr/local/CEoR /usr/local/CEoR/bin /usr/local/CEoR/etc /usr/local/CEoR/MODs /usr/local/CEoR/RCPs; do
  if [ -e ${i} ] && [ ! -d ${i} ]; then
    echo "Error: ${i} is not Directory."
    exit 1
  else
    mkdir $i
  fi
done

[ ! -d "./MODs" ] && "Error: Run this script on CEoR top directory" && exit 1

cp -r ./MODs/* /usr/local/CEoR/MODs
cp -r ./RCPs/* /usr/local/CEoR/RCPs
cp -r ./bin/* /usr/local/CEoR/bin
