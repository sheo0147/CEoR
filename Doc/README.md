# CEoR : Command Executer on Remote 

(English version is here)[https://github.com/sheo0147/CEoR/blob/master/Doc/README_en.md)

## 実装に関するメモ 

* CEoRを含む中心となるScriptは、「POSIXで規定されている」範囲のみで作成する
* CEoRを構成するScriptには、以下の3種類がある
  * 中心となるMain Script (CEoRなど) : 以下 "MS"
  * Module Script (adduserなど) : 以下 "SS"
  * 一連の作業を手順を記述したRecipie Script : 以下 "RS"

## Scriptの記述ルール
scriptとは、Recipe, Moduleを含む、CEoRが利用する一連のファイル・関数群のことをいう

* Scriptの先頭には必ずScriptの役割を記述する
* 各スクリプトの先頭部にはLicence条項を記載する事が望ましい
  * CEoRとして公開するScript群は「2条項BSDライセンス」のもののみとする
* インデントにはTabは利用せず、Space(0x20)を利用する
  * Space 2個を1インデント単位とする
* Script内で使用する変数（環境変数）名は、以下のような形式とする
  * MS内で使用する環境変数 : `__[A-Z0-9_]+`
  * SS内で使用する環境変数 : `_[A-Z0-9_]+`
  * RS内で使用する環境変数 : `[A-Za-z0-9_]+`
* 予約された環境変数
  * `CEoRETC/CEoRINC/CEoRLOCINC/CEoRPRJINC/DEBUG/[A-Za-z0-9_]+_(TEST|DEBUG)`
  * `__`で始まる全ての環境変数
* 変数参照は ${VARNAME} 形式を利用する
* 可能なかぎり、DEBUGコード及びTESTコードを含める
  * TESTコードは、(Functionname)_TESTによって分離し、その中に記載すること

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

* コメントは、必要最小限にとどめる
  * 原則英語を使用する。それ以外の文字種を利用する場合、文字コードにUTF-8を利用する
* 全てのModule関数は、必ず返り値を持つこと
  * 正常終了の場合 : 0
  * 以上終了の場合 : 非0 (特別な理由がない限り 1 を利用する)
* 関数から終了ステータス以外の何らかの値を返したい場合には、関数内でstdoutに出力する
  * 呼び出し側は関数をBack Quoteで括って呼び出し、環境変数に代入する事で値のやり取りを行う

### CEoRにおけるModuleの制限

CEoRでは、様々な処理を行うために、Moduleとして記述した関数を呼び出すという手法を採用している。
現時点では、Moduleが少ないので、CEoR内にてModuleを全て読み込んでいる。
従って、CEoRには以下の制約がある。

* CEoRGENINC / CEoRLOCINC / CEoRPRJINC 内に、同名のModule(関数)が存在してはならない。
  * 正確には、同名の関数が存在した場合、一番最後に読み込まれたModuleが利用される。これは実行上のトラブルになりかねないので、CEoRとしては禁止する。（ただしチェックはしていない）

## その他のメモ

### getconfs.rcp/putconf.rcpにおける実装メモ

### システム情報の取得 
システムの設定ファイルの取得・書戻の際、設定ファイルのPermissionやflagなどが問題になる。
この種の情報の扱いに関して、以下に記載する

#### File Attributeの記録 
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

##### FreeBSD 

* FreeBSDは、通常のFile Permissionに加えて拡張属性を持つ。
  * 詳細は man chflags を参照
  * lsで情報を取得する場合、ls -lo などとする
  * statで拡張属性を取る場合、通常10.0系以前はstat情報が設定されていない
  * chflagsの引数に、stat で取得した flag 情報を引き渡すことで、拡張属性の設定が可能

##### CentOS 

* CentOS7は、標準でselinux拡張属性(Security Context)がファイルに割り振られている
  * seLinuxのsecurity contextを復帰するには、restorecon を利用するのが簡易
    * chconでも実行可能
  * restorecon -F filename で強制的にシステムに記録されている標準状態に戻すことができる

#### Ubuntu 

* Ubuntuは標準ではseLinux関連のSecurity Contextは設定されていない
  * AppArmorという仕組みを利用しているようだが、詳細は未調査
