#!/bin/sh
##############################################################################
#
#  mkceordir.sh		: Create CEoR directory and put configuration.
#
# for /usr/bin/what:
#  @(#) mkceordir.sh : Create CEoR directory and put configuration.
#
##############################################################################


##############################################################################
##### Create ~/.CEoR
##############################################################################
echo "Create ~/.CEoR and some directories, personal configuration file."
for i in ~/.CEoR ~/.CEoR/MODs ~/.CEoR/RCPs; do
  if [ -e ${i} ]; then
    echo "${i} is exist... skip"
  else
    mkdir $i
  fi
done
if [ -e ~/.CEoR/ceor.conf ]; then
  echo "~/.CEoR/ceor.conf is exist... skip"
else
  cat << '__END__' > ~/.CEoR/ceor.conf
#
# ~/.CEoR/ceor.conf:	CEoR Personal Configuration.
#
# for /usr/bin/what:
#  @(#)CEoR Personal Confguration file.
#

[PATH]		# PATH configurations
MODULE : ~/.CEoR/MODs	# Private addtional modules
RECIPE : ~/.CEoR/RCPs	# Private addtional recipes

[OTHER]		# PATH configurations but overwrite
__NODECONF : ~/NodeConfs		# place of backup configuration data
__WORKS    : ${__NODECONF}/.wrks	# working directory
__INFOS    : ${__NODECONF}/infos	# target node information data
__CONFS    : ${__NODECONF}/confs	# target node configuration files
__BAKCONFS : ${__NODECONF}/bakconfs	# node configuration backup files
__END__
fi
##### done.
