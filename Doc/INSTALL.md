# Installation 

Now work in progress.

## Environment.
CEoR needs following environment.
* Many of POSIX commands.
  * WARNING. Currently ceor use some not POSIX commands on shell.
  * I tested /bin/sh on FreeBSD, /bin/sh(bash) on CentOS 7, /bin/sh(dash) on Ubuntu 17.10, /bin/sh(bash) on macOS 10.13
* ssh, openssl, sudo, ...

## How to Install

* Get CEoR from github
* Run followings
```
$ cd some/where/CEoR
$ sudo sh bin/instceor.sh
$ sh bin/mkceordir.sh
```
* Check directories.
  * CEoR distribution file is put under `/usr/local/CEoR`
  * Personal configuration is put under `~/.CEoR`
  * Projects configuration is put under `./.CEoR`

## Execute sample recipe

```
% /bin/sh /usr/local/CEoR/bin/ceor.sh -u UserName -h TargetHost concept.rcp
```
and then, run `ls -l` on TargetHost.
