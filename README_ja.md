# CEoR : Command Executer on Remote 

## Overview 

CEoR は、ssh/scp などを利用し、望んだコマンドを対象ノードで実行させるための shell script である。

## Motivation / 実装の動機 

Chef/Ansible/Fablicは、設定の自動化ツールとして広く知られている。

これらのツールは明示的にもしくは暗黙に、対象ノードがLinuxであることを仮定している。ツール単体はそうでなかったとしても、利用可能なライブラリーやモジュール、レシピがLinuxを仮定している。加えて、実行環境にrubyやPythonなど、システムの配布時点で存在を仮定できないツールの利用を要求する。

私の場合、FreeBSD/NetBSD, CentOS/Ubuntu等の様々なOSを管理しており、しばしば、対象ノードにPythonやRubyを導入できないことがある。このような状況において、上記制限は非常に厳しい。

そのため、POSIX shellやその他POSIXに定義されているコマンドで実行できるCEoRを実装した。

## 実装における思想 

CEoRは、最小限のツールで動作をさせることを目的としている。したがって、POSIX UNIXに標準搭載されているコマンドのみで動作させるのが原則である。ssh/sudoなど一部のコマンドはPOSIX UNIXの標準コマンドではないが、自動化を目標とする本ツールの実装上必要なので、採用している。
コマンドの参照元: [[http://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html]]

  多くのUNIXにおいて、sudoの代わりにsuを利用することは可能である。
  しかしながら、共通パスワードの使用など様々な問題があるため、CEoRではsudoを利用する

なお、現時点で仮定している非標準コマンドは以下の通りである
* ssh / sudo : 必須
* pkg / yum / apt : (FreeBSD|CentOS|Ubuntu)システムにおいて必要
* openssl : 一部Hash計算に利用
* wget / curl : 将来必要になる可能性がある

## 実行における仮定条件 

CEoRを実行するにあたって要求されるソフトウェアを記載する。

### 必須条件 

* 制御側
  * ssh 5.6 以上(2010年8月リリース)
  * POSIX Shell およびPOSIXで規定されている各種コマンド
* 被制御側
  * sshd 5.6 以上(2010年8月リリース)
  * POSIX Shell およびPOSIXで規定されている各種コマンド
  * 必要になる各種制御系コマンド
    * 可能な限り対話式処理を利用しないことが望ましい

### 望ましい条件 

* 制御側から被制御側に入力なしでloginできる環境
* 被制御側において、必要時に特権を取得することができる何らかの設定
  * 一般にはsudoを利用することが多いが、suコマンドで代行するなども可能

### CEoRの構造 

CEoRはshell scriptなので、その処理のほとんどを環境変数に頼る形で実装している。

CEoRには、複数のPATHを記載するためのPATH型変数と、固定の値を持つ固有値型変数がある。

* 標準で定義されるPATH型変数
  * $BIN:    /usr/local/CEoR/bin
  * $CONFS:  /usr/local/CEoR/etc
  * $MODULE: ./.CEoR/MODs ~/.CEoR/MODs /usr/local/CEoR/MODs
  * $RECIPE: ./.CEoR/RCPs ~/.CEoR/RCPs /usr/local/CEoR/RCPs

これらの変数は、複数のPATHを space(0x20)で区切って定義する。
評価は先頭から行われる。したがって、
  * ./CEoR/RCPs/foo.rcp
  * /usr/local/CEoR/RCPs/foo.rcp
が存在する場合には、./CEoR/RCPs/foo.rcpが選択される。

```
/ -+- /usr/local/CEoR -+- bin ---- ceor.sh   : 実行ファイル
   |                   +- etc ---- ceor.conf : 基本設定ファイル
   |                   +- MODs -+
   |                   |        +- ....      : CEoRで配布しているModule
   |                   |
   |                   +- RCPs -+
   |                            +- ....      : CEoRで配布しているRecipe
   +- ~/.CEoR -+- ceor.conf                  : [個人]
   |           +- MODs -+
   |           |        +- ....              : 個人で作成したModule
   |           |
   |           +- RCPs -+
   |                    +- ....              : 個人で作成したRecipe
   |
   +- Proj -+                                : [プロジェクト]
            +- .CEoR -+
                      +- ceor.conf.local     : プロジェクト単位での設定ファイル
                      +- MODs -+
                      |        +- ....       : プロジェクト単位で作成したModule
                      |        |
                      +- RCPs -+
                               +- ....       : プロジェクト単位で作成したRecipe
```

* 標準で定義される固有値型変数
  * $SSH:    System内で標準的に読み出される ssh コマンド (/usr/bin/ssh)
  * $SED:    System内で標準的に読み出される sed コマンド (/usr/bin/sed)
  * その他変数定義は、/usr/local/CEoR/etc/ceor.confを参照のこと
  * 固有値変数定義の優先順位は、Proj/.CEoR/ceor.conf.local, ~/.CEoR/ceor.conf.local, /usr/local/CEoR/etc/ceor.conf となる。したがって、以下のように設定した場合、SSH="./bin/ssh" となる。
    * /usr/local/CEoR/etc/ceor.confで SSH=`which ssh`
    * ./CEoR/ceor.conf.localでSSH="./bin/ssh"
  
## 各種のルール 

### Configuration file 

* 設定ファイルは、`key : Value` 形式で記述する
  * 例はrepository内の ceor.conf を参照

### Module file 

* Moduleは「何らかの機能」を「Platformに依存せずに」実行させるためのものである。
  * 実施させたい作業を抽象化したもの
  * 例えば、Userを追加するためのadduserという機能をModuleとして実装する場合以下を考える
    * CentOSの場合: useradd を利用。
    * Ubuntuの場合: useradd を利用。
    * FreeBSDの場合: adduser を利用。
    * それぞれでOptionを設定する必要がある。(UID/GID/Groups...)
    * これらを引数に取る必要があるので、関数呼び出し時に引数として与えてもらう
    * checkosしてOS毎にコマンドを生成し実行する
    * exit statusを確認し、成功の場合exit 0/失敗の場合exit 1を実行する
* Moduleは内容がたった1行であっても、1ファイルに1 functionとして記載する
* 関数名とモジュールファイル名は必ず一致させる
  * 存在するモジュールがわかりやすくなるように
* 同一のモジュール名がある場合、以下の順に読み出す
  * Proj/.CEoR -> CEoRLOCINC -> CEoRGENINC
* 函数名は原則として`[a-z0-9_]+`で表記する
  * 要するにAlphabet大文字は使わない
  * Cammel-Caseを認めるかは議論の余地がある
* POSIX 非標準コマンドを利用する場合、Moduleのコメント部に記載すること

### Recipe 

* Recipeとは、作業手順を記述したものである
* Recipeは以下の3つブロック(関数)で構成される
  * prepare : 事前準備。Recipeを呼び出したnode(local)で実行される
    * 必要に応じて、ファイルなどを準備し、実行先に転送しておくこともできる
  * main : 実作業。対象node(remote)で実行される
    * mainはremoteで実行されるため、localの環境変数設定は引き継がれない
    * 現時点で引き継がれる環境変数は`__TGT_SCRDIR`と`__TGT`の二つのみ
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

