# インストール 

まだ、作業中です。

## 環境について
CEoR が必要とする環境。
* POSIX コマンド類。
  * WARNING. CEoRはPOSIXコマンド以外も利用しています.
  * 以下の環境でテストされています。
    * /bin/sh：FreeBSD
    * /bin/sh(bash)：CentOS 7
    * /bin/sh(dash)：Ubuntu 17.10
    * /bin/sh(bash)：macOS 10.13
* ssh, openssl, sudo, ...

## インストールの手順

* CEoRをgithubから取得します。
* 以下のコマンドを実行します。
```
$ cd some/where/CEoR
$ sudo sh bin/instceor.sh
$ sh bin/mkceordir.sh
$ cd your/project/dir
$ sh bin/mkceorprjdir.sh
```

* 以下のディレクトリが作成されていることをチェックしてください。
  * `/usr/local/CEoR`：CEoRの本体が格納されています
  * `~/.CEoR`：ユーザ設定を格納します
  * `./.CEoR`：project設定を格納します

## サンプルレシピの実行

```
% /bin/sh /usr/local/CEoR/bin/ceor.sh -u UserName -h TargetHost concept.rcp
```

リモートホスト上で`ls -l`が実行されます。
