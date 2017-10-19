# CEoR : Command Executer on Remote 

## Memorandom of Imprementations

* CEoR and its affiliation should be created only within the range specified by POSIX.
* There are three types of scripts that compose CEoR.
  * Main Script (like CEoR)            : descripted as "MS"
  * Module Script (like adduser.mod)   : descripted as "SS"
  * Recipie Script (like getconfs.rcp) : descripted as "RS"

## Script description rule.
Hereinafter, "Script" is defined as a series of files/functions used by CEoR such as Recipe, Module.

* Describe the role of Script at the beginning of Script.
* It is desirable to include the License clause at the beginning of each script.
  * The Script group to be released as CEoR shall be only those of "2 clause BSD license"
* Do not use Tab for indentation in Script, use Space (0x20).
  * 1 indent use 2 spaces.
* Variable names used in Script should be in the following format.
  * In MS : `__[A-Z0-9_]+`
  * In SS : `_[A-Z0-9_]+`
  * In RS : `[A-Za-z0-9_]+`
* Reseerved Variables
  * `CEoRETC/CEoRINC/CEoRLOCINC/CEoRPRJINC/DEBUG/[A-Za-z0-9_]+_(TEST|DEBUG)`
  * All environment variables beginning with `"__"`
* Use ${VARNAME} format.
* Include DEBUG and TEST codes whenever possible.
  * The TEST code should be separated by `Functionname_TEST` and described in it.

```
: ${checkos_TEST:=0}
checkos() {
....
}
# Test code
if [ ${checkos_TEST} ]; then
  for _OPT in "  " "-k" "-K" "-d" "-D" "-h" "-a" "- "; do
    _RET=`checkos ${_OPT}`
    echo "RetCode=${?} / Opt=\"${_OPT}\" / RetString: ${_RET}"
    echo
  done
fi
```

* Comments should be kept to the minimum necessary.
  * In principle use English. When using other character types, use UTF-8.
* All Module functions have return values.
  * Normal termination   : 0
  * Abnormal termination : non 0 (Basically using 1)
* If you want to return some value from a function, it is output to stdout in the function.
  * According to the general way in Shell script, the caller calls functions by Back Quote and assigns them to environment variables.

### Module restriction in CEoR

CEoR is calling a function described as Module in order to perform various processes.
Currently, since there are few Modules, CEoR is reading all Modules.
Therefore, CEoR has the following restrictions.

* There must nt be exist the same name Module/Function in CEoRGENINC / CEoRLOCINC / CEoRPRJINC.
  * When "Module/function" of the same name exists, the most recently loaded "Module/function" is used.
  * Since this can cause trouble in execution, it is prohibited as CEoR. (But not checked)

## Other memos

### getconfs.rcp/putconf.rcp

### Getting system configurations
Permission and flag of the configuration files become problems at the time of getting/writing back the system.

#### Record of the File Attributes
Information on the target file in each OS is described in info/node/stat.txt

Format is `Permission HardLinkCount Username UID Group GID "Extended attribute" filename`

Followings are example of FreeBSD 11.1.
```
100644 1 root 0 wheel 0 "uarch" etc/remote
100644 1 root 0 wheel 0 "uarch" etc/hosts
100644 1 root 0 wheel 0 "uarch" etc/ttys
```

Followings are example of CentOS 7.
```
644 1 root 0 root 0 "system_u:object_r:etc_t:s0" etc/fonts/conf.d/README
644 1 root 0 root 0 "system_u:object_r:etc_t:s0" etc/fonts/fonts.conf
0 1 root 0 root 0 "system_u:object_r:shadow_t:s0" etc/gshadow
```

##### FreeBSD 

* FreeBSD has normal File Permissions and extended permissions.
  * See `man chflags`
  * when get extended attribute, use `ls -lo`
  * Version 10.0 or earlier, files has not to set extended attributes.
  * Extended attributes can be set by using flag information acquired by stat as an argument of chflags.

##### CentOS 

* The CentOS 7's file has selinux extended attribute (Security Context) set as standard.
  * Use restorecon to easily set seLinux security context.
    * Can also be chcon.
  * It is possible to forcibly set to the standard state recorded in the system with restorecon -F filename.

#### Ubuntu 

* On Ubuntu, it does not set seLinux related Security Context by default.
  * It seems to be using the mechanism called AppArmor, but details are not yet investigated.
