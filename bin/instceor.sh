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
##############################################################################
##### create /usr/local/CEoR 
##############################################################################
if [ $(id -u) -eq 0 ]; then
  echo "Create /usr/local/CEoR and some directories, system wide configuration file."
  for i in /usr/local/CEoR /usr/local/CEoR/bin /usr/local/CEoR/etc /usr/local/CEoR/MODs /usr/local/CEoR/RCPs; do
    if [ -e ${i} ]; then
      echo "${i} is exist... skip"
    else
      mkdir $i
    fi
  done
  if [ -e /usr/local/CEoR/etc/ceor.conf ]; then
    echo "/usr/local/CEoR/etc/ceor.conf is exist... skip"
  else
    cat << '__END__' > /usr/local/CEoR/etc/ceor.conf
#
# ceor.conf:	CEoR System-wide Default Configuration.
#
# for /usr/bin/what:
#  @(#)CEoR Confguration file.
#

# PATH configuration is deduplication and concat
[PATH]		# PATH configurations
BIN    : /usr/local/CEoR/bin
CONFS  : ./.CEoR:~/.CEoR:/usr/local/CEoR/etc
MODULE : /usr/local/CEoR/MODs
RECIPE : /usr/local/CEoR/RCPs

# Other configuration is overwrite
[OTHER]
SSH_CONFIG : ~/.ssh/config
__END__

  fi
fi
##############################################################################
##### Install CEoR to /usr/local/CEoR
##############################################################################

echo "Install CEoR to /usr/local/CEoR"
for i in /usr/local/CEoR /usr/local/CEoR/bin /usr/local/CEoR/etc /usr/local/CEoR/MODs /usr/local/CEoR/RCPs; do
  if [ -e ${i} ] && [ ! -d ${i} ]; then
    echo "Error: ${i} is not Directory."
    exit 1
  else
    mkdir -p $i
  fi
done

[ ! -d "./MODs" ] && "Error: Run this script on CEoR top directory" && exit 1

cp -r ./MODs/* /usr/local/CEoR/MODs
cp -r ./RCPs/* /usr/local/CEoR/RCPs
cp -r ./bin/* /usr/local/CEoR/bin
