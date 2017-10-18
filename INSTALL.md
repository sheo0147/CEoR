# Installation 

Now work in progress.

* Get CEoR from github
* Prepare to run

```
cp ceor.conf.sample ceor.conf
cp ceor.conf.local.sample ceor.conf.local
echo ': ${CEoRETC:="./ETC"}' >> ceor.conf.local
echo ': ${CEoRGENINC:="./MODs"}' >> ceor.conf.local
mkdir ~/NodeConfs
```

Done.

getting configuration file.
```
/bin/sh ceor.sh -h [target node] -u [account] RCPs/getconf.rcp
```
Then target node configuration files to ~/NodeConfs/confs.
