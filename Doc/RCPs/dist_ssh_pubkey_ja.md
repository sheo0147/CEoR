# Distribution ssh public key.

## 目的
ssh接続用公開鍵の配布。
管理者が利用ユーザの一括追加などを行う際に使用することを想定しています

## Reqirement

[CEoR](https://github.com/sheo0147/CEoR)を利用しています。

[CEoR](https://github.com/sheo0147/CEoR)のRCPとして実装しています。

## 注意点

- sudoが存在していることを想定しています。
- 作業ユーザにsudo権限があることを想定しています。
- 公開鍵は`/home/user/.ssh/authorized_key`に配置されます。
- `/home/user/.ssh/authorized_key`は再作成されますので、設定にない鍵は全て**削除**されます(**追加**でありません)

## 事前準備

[CEoR](https://github.com/sheo0147/CEoR)本体については割愛。

### 作業ディレクトリの作成

```
$ mkdir work
```

### CEoRディレクトリの作成

```
$ cd work
$ sh /usr/local/CEoR/bin/mkceorprjdir.sh
```

カレントに`./.CEoR`ディレクトリが作成されます。

### サンプルスクリプトのコピー

`github`から持ってきた本体の`SampleScript`にある、`dist_ssh_pubkey.sh`をコピーします。

### configの設定

./.CEoR/ceor.confに以下の値を記述します。

```
__PUBKEYS     : ./pubkeys
__TARGETCONFS : ./conf.d
__KEYARCHS    : archives
```

### 配布先のリスト作成

配布先のリストを作成します。
`${ALL_TARGET}`という名称の変数に格納してください。

#### nodelist.sh

``` ini
PROXY="PX001 PX002"
WEB="WEB1 WEB2"

ALL_TARGET="${PROXY} ${WEB}"

```

### 公開鍵の準備

公開鍵をおくディレクトリを作成し、その中に公開鍵ファイルを設置します。

```
$ mkdir pubkeys
$ cp /path/to/keys/publickey ./pubkeys
  ......
```

### ホストごとの設定

設定をおくディレクトリを作成し、その中に設定ファイルを設置します。

```
$ mkdir conf.d
```

設定ファイルは`nodelist.sh`の`ホスト名.sh`という名前になっています

```
$ ls -la
................    PX001.sh
................    PX002.sh
................    WEB1.sh
................    WEB2.sh

```

設定ファイル中はユーザ、公開鍵ファイル名のリストになっています。

```

##        user            public_key_file
_KEYLIST="
          user01          user01.pub
          user02          user02.pub
         "
```

## 公開鍵の配布

```
$ sh ./dist_ssh_pubkey.sh
```
### 注意点

- このサンプルscriptでは、リモートでの作業ユーザは`~/.ssh/config`で設定されていることを想定しています。


