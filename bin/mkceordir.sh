#!/bin/sh
##############################################################################
#
#  mkceordir.sh		: Create CEoR directory and put configuration.
#
# for /usr/bin/what:
#  @(#) mkceordir.sh : Create CEoR directory and put configuration.
#
##############################################################################

ROOT=0
[ "${UID}" = "0" ] && ROOT=1

##############################################################################
##### create /usr/local/CEoR (if UID=0)
##############################################################################
if [ ${ROOT} -eq 1 ]; then
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
CONFS  : /usr/local/CEoR/etc
MODULE : /usr/local/CEoR/MODs
RECIPE : /usr/local/CEoR/RCPs

# Other configuration is overwrite
[OTHER]		# Other configurations
SSH    : `which ssh`
SED    : `which sed`
AWK    : `which awk`
GREP   : `which grep`
MKTRMP : `which mktemp`

[OTHER]
SSH_CONF : ~/.ssh/config
__END__

  fi
fi

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
if [ -e ~/.CEoR/ceor.conf.local ]; then
  echo "~/.CEoR/ceor.conf.local is exist... skip"
else
  cat << '__END__' > ~/.CEoR/ceor.conf.local
#
# ~/.CEoR/ceor.conf.local:	CEoR Personal Configuration.
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
__PKGS     : ${__NODECONF}/pkgs		# target node package configuration files.

[OTHER]
SSH:'/usr/local/bin/ssh'
__END__
fi

##############################################################################
##### Create ./.CEoR
##############################################################################
echo "Create ./.CEoR and some directories, project configuration file."
for i in ./.CEoR ./.CEoR/MODs ./.CEoR/RCPs; do
  if [ -e ${i} ]; then
    echo "${i} is exist... skip"
  else
    mkdir $i
  fi
done
if [ -e ./.CEoR/ceor.conf.local ]; then
  echo "./.CEoR/ceor.conf.local is exist... skip"
else
  cat << '__END__' > ./.CEoR/ceor.conf.local
#
# ./ceor.conf.local:	CEoR Per Project Configuration.
#
# for /usr/bin/what:
#  @(#)CEoR Local Confguration file.
#

[PATH]		# PATH configurations
MODULE : ./CEoR/MODs:./MODs		# Prj addtional modules
RECIPE : ./CEoR/RCPs:./RCPs		# Prj addtional recipes

[OTHER]		# Other configurations.
DEBUG    : 0				# for DEBUG
MOD_TEST : 0				# for Module test mode

[OTHER]		# PATH configurations but overwrites
__NODECONF : ./NodeConfs		# place of backup configuration data
__WORKS    : ${__NODECONF}/.wrks	# working directory
__INFOS    : ${__NODECONF}/infos	# target node information data
__CONFS    : ${__NODECONF}/confs	# target node configuration files
__BAKCONFS : ${__NODECONF}/bakconfs	# node configuration backup files
__PKGS     : ${__NODECONF}/pkgs		# target node package configuration files.
__END__
fi
##### done.
