# CEoR : Command Executer on Remote 

[Installation memo is here](https://github.com/sheo0147/CEoR/blob/master/INSTALL.md)

## Overview 

CEoR is a tool written by POSIX shell script which runs procedures on remote node using ssh/scp.

## Motivation 

Chef/Ansible/Fablic are widely known as tools for automatically setting on remote nodes.

These tools explicitly or implicitly assume that the target is Linux. In many case, tools are not assume it, but usable libraries or module or recipes are assumeing Linux.
And these tools require use of tools such as ruby, python or others that can not be assumed to exist in the system at the time of system distribution.

I'm administrating FreeBSD/NetBSD, CentOS/Ubuntu or other OSs, and sometimes I cannot install ruby, python or other tools to the target nodes.
Under these circumstances, these restrictive conditions are very strict.

So I imprement CEoR. CEoR runs on POSIX shell and other POSIX commands.

## Philosophy 

CEoR producted for the purpose of operating with minimum toolsets. Then CEoR uses only POSIX UNIX toolset.
Actually, due to implementation circumstances, I use some tools not included in POSIX like ssh or sudo and so on.

* A list of posix commands: [[http://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html]]

```
On many UNIX systems, it is possible to use su instead of sudo.
But CEoR uses sudo because using su has some probrems like sharing password.
```

Followings are a list of non POSIX commands which using CEoR.
* ssh / sudo : Must
* pkg / yum / apt : Need to use FreeBSD/CentOS/Ubuntu
* wget / curl / openssl : should be

## Precondition 

Below, list the software required to execute CEoR.

### MUST 

* local node
  * ssh 5.6 or above (2010/08 released.)
  * POSIX Shells and commands
* Target node
  * sshd 5.6 or above (2010/08 released.)
  * POSIX Shells and commands
  * Some of the administration commands
    * It is desirable not to use interactive processing whenever possible.

### SHOULD 

* login with no password on remote. (Recomend to use ssh RSA authentication.)
* Elevated privilege to root with no password on remote.
  * Generally use sudo.

### Structure of CEoR 

* Default value (configured in ceor.conf or ceor.conf.local)
  * CEoRETC: /usr/local/etc
  * CEoRINC: /usr/local/libexec/CEoR
  * CEoRINC_LOCAL: ./.CEoR
    
```
/ -+- some/where/bin -+- ceor.sh        : Executer
   |                  +- ceorconf.sh    : System Configuration File getter/putter
   |
   +- CEoRETC -+- ceor.conf
   |
   +- CEoRGENINC -+- GM_checkos         : Generic function module
   |              +- GM_package -+- GM_pkg_add
   |              |              +- GM_pkg_update
   |              +- GM_user -+- GM_user_add
   |              |           +- GM_user_del
   |              +- GM_....
   |
   +- CEoRLOCINC -+- LM_nginx           : Local function module
   |              +- LM_crs
   |              +- LM_postfix
   |
   +- Proj_A -+- .CEoR -+- M_nginx      : Project function module
              |         +- M_postfix
              +- R_tmpl                 : node recipies
              +- R_wb
              +- R_waf -----+- R_waf_os
                            +- R_waf_nginx
                            +- R_waf_crs
```

#### Example: Strcture of getconf/putconf recipe 

You can configure in ceor.conf.local (or ceor.conf)

```
${NODECONF}-+- .wrks
            +- infos -+- node1          # ${INFOS}
            |         +- node2
            |
            +- confs -+- node1          # ${CONFS}
            |         +- node2
            |
            +- bakconfs -+- node1       # ${BAKCONFS}
            |            +- node2
            |
            +- pkgs-+- etc -+- node1    # ${PKGS}
                    |       +- node2
                    +- nginx -+- node1
                              +- node2
 ```

## Some Rules 

### Configuration file 

* Read order of configuration.
  * ./ceor.conf.local -> ${CEoRETC/ceor.conf} -> /usr/local/etc/ceor.conf
* Write the configuration file in "Shell script" format
  * See ceor.conf.sample or ceor.conf.local.sample

### Module file 

* Module is to make "some function" execute "without depending on Platform".
  * Module is an abstraction of the work you want to implement.
  * For example, when implementing the function "adduser" for adding "User" as Module, consider the following
    * on CentOS: use "useradd"
    * on Ubuntu: use "useradd"
    * on FreeBSD: use "adduser"
    * Need to set some options such like UID, GID, Groups, and so on.
    * It is necessary to pass option as an argument.
    * OS check uses checkos.
    * Check "exit status", and return status. 0 is Succeeded, 1 is failed.
* Module creates one file for each module, even if the contents are only one line.
* Always make sure that the function name and module file name match.
  * Ensure that existing module names are easy to understand.
* If there is the same module name, CEoR reads in the following order
  * Proj/.CEoR -> CEoRLOCINC -> CEoRGENINC
* Function name should be created according to [a-z0-9_]+
  * Do not use upper case alphabet.
  * Now I'm considering function name by Cammel-Case.
* If a module using not POSIX commands, comment it in the comment part of module.

### Recipe 

* Recipeは、作業手順を記述したものである。
* Recipeは、Moduleやshell scriptで実施できる制御文を組み合わせて記述する
* Recipeには、汎用的なものもSpecificなものも記述できる。
* Recipeは以下の3つブロックから構成される
  * prepare : 事前準備。Recipeを呼び出したnode(local)で実行される
    * 必要に応じて、ファイルなどを準備し、実行先に転送しておくこともできる
  * main : 実作業。対象node(remote)で実行される
  * afterwords: 事後処理。localで実行される
    * 必要に応じて、mainで作成されたファイルなどを取得することもできる
* 各ブロックはshell scriptにおける関数のように記述される必要がある。
  * サンプルはRCPs/concept.rcpを参照

```
prepare(){ # localで実行される
# exit statusが0でなければ、CEoRは停止することに注意
}
main(){ # remoteで実行される
  ls -l /	# 実行したい内容をshell scriptとして記述する
# exit statusが0でなければ、CEoRは停止することに注意
}
afterwords(){ # localで実行される
# exit statusにかかわりなく、最終処理を実行後CEoRが終了する
}
```

## 実装メモ 

* CEoRを含む中心となるScriptは、「POSIXで規定されている」範囲のみで作成する
  * ShellはPOSIX Shell
  * sed/awkはPOSIX規定のものに
* CEoRを構成するScriptには、以下の4種類がある
  * 中心となるMain Script (CEoRなど) : 以下 "MS"と記載
  * 機能モジュールとして動作するSubfunction Script (adduserなど) : 以下 "SS" と記載
  * 一連の作業を手順を記述したRecipie Script : 以下 "RS" と記載
  * Receipe等を呼び出して処理を束ねるPersonal Script : 以下 "PS"　と記載
* 各Scriptを記載するためのルールを以下に記載する
  * 各Scriptの先頭には必ずそのScriptで行う内容を記載する
  * 各スクリプトの先頭部にはLicence条項を記載する
    * Licenseは、BSD 2条項とする
  * Tabは利用せず、Space(0x20)を利用したIndentを行う
    * Indentは原則 2SPC 単位とする
  * Script内で使用する変数（環境変数）は、原則として以下のようなルールとする
    * MS内で使用する環境変数    : __[A-Z0-9_]+
    * SS内で使用する環境変数    : _[A-Z0-9_]+
    * RS/PS内で使用する環境変数 : [A-Za-z0-9_]+
  * 予約された環境変数
    * CEoRETC/CEoRINC/CEoRLOCINC/CEoRPRJINC/DEBUG/[A-Za-z0-9_]+_(TEST|DEBUG)
  * 変数参照は ${VARNAME} 形式を利用する
  * 可能である限り、DEBUGコード及びTESTコードを含むこと
    * TESTコードは、(Functionname)_TESTによって括られ、その中に記載されること

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

  * コメントは、必要最小限にとどめる。
    * 原則英語で。それ以外の文字種を利用するならばUTF-8を利用する
  * 全ての機能函数は、必ず返り値を持つこと
    * 正常終了の場合 : 0
    * 以上終了の場合 : 非0 (特別な理由がない限り 1 を利用する)
  * 函数から何らかの値を返したい場合、stdoutに出力すること
    * 呼び出し側は Back Quote で函数を括って呼び出し（評価し）、変数で受けること

## 各種メモ 

### モジュールの読み込み 

CEoRにおいて様々な処理はModuleと呼ばれる複数の函数群において実行される。
現時点では、函数が少ないので、ceor内で函数を全て読み込み、展開することでレシピの実行を行えるように実装している。

この実装において、現時点では「良いアイデアもない」ので、以下の制約がある。

* CEoRGENINC / CEoRLOCINC / CEoRPRJINC 内に、同名の函数が存在してはならない。
  * ${CEoRGENERIC}/checkos と ${CEoRPRJINC}/checkos が存在した場合、実行時に生成されるファイル内に「同じ名前の函数」が「複数」定義されてしまう。エラーになるかどちらかを実行するかはshellの実装に依存するので、問題が発生することがある。
  * なお、OS-X High Sierra/FreeBSD 11.1/Ubuntu 17.04 の/bin/sh及び、CentOS7の/bin/sh(bash)場合、後から定義された函数が実行される

### システム情報取得 

システムの設定ファイルの取得・書戻の際、設定ファイルのPermissionやflagなどが問題になる。
この種の情報の扱いに関して、以下に記載する

### statusの記録 

各OSにおいて、対象ファイルの情報を info/node/stat.txt に記載する
Formatは、
```
Permission HardLinkCount Username UID Group GID "拡張属性" ファイル名
```
とする。以下、FreeBSD 11.1の例
```
100644 1 root 0 wheel 0 "uarch" etc/remote
100644 1 root 0 wheel 0 "uarch" etc/hosts
100644 1 root 0 wheel 0 "uarch" etc/ttys
```
以下CentOS7の例
```
644 1 root 0 root 0 "system_u:object_r:etc_t:s0" etc/fonts/conf.d/README
644 1 root 0 root 0 "system_u:object_r:etc_t:s0" etc/fonts/fonts.conf
0 1 root 0 root 0 "system_u:object_r:shadow_t:s0" etc/gshadow
```

#### FreeBSD 

* FreeBSDは、通常のFile Permissionに加えて拡張属性を持つ。
  * 詳細は man chflags を参照
  * lsで情報を取得する場合、ls -lo などとする
  * statで拡張属性を取る場合、通常10.0系はstat情報がないことに注意
  * chflagsの引数に、stat で取得した flag 情報を引き渡すことで、拡張属性の設定が可能

#### CentOS 

* CentOS7は、標準でselinux拡張属性(Security Context)がファイルに割り振られている
  * seLinuxのsecurity contextを復帰するには、restorecon を利用するのが簡易
    * chconでも実行可能
  * restorecon -F filename で強制的にシステムに記録されている標準状態に戻すことができる

#### Ubuntu 

* Ubuntuは標準ではseLinux関連のSecurity Contextは設定されていない
  * seLinuxに関してはCentOSと同等(と思われる)
