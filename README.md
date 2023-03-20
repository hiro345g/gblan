# gblan

gblan は Web アプリの開発を効率よくするための開発環境を Docker で用意するためのテンプレートを提供します。
gblan という名前の由来は、開発の目的である「[GitBucket](https://github.com/gitbucket/gitbucket) を含めた開発環境を LAN 環境で簡単に用意できるようにする」にあります。

gblan には次の3つの特長があります。

- Docker 環境で動作
- Git リモートリポジトリー対応
- HTTPS 対応の Web サーバー

効率良い Web アプリの開発をするためには、Docker の利用、Git リモートリポジトリーの利用が必須です。また、LAN 環境で HTTPS 対応の Web サーバーが手軽に動作するということも必要です。

gblan は Docker で動作するようにしてあるので、Docker 環境を用意すればどこでも使えます。稼働マシンとしては、[Docker Engine](https://docs.docker.com/engine/) が動作する専用マシンがあると良いのですが、普段使用している [Docker Desktop](https://docs.docker.com/desktop/) をインストールした開発マシン上でも稼働できるよう、比較的軽量な Docker イメージを使ってテンプレートを作ってあります。

gblan を使うと、最近の開発時には必須の Git リモートリポジトリーも含めて開発環境を用意することができます。Git リモートリポジトリーの提供にあたっては、[GitBucket](https://github.com/gitbucket/gitbucket)と [PostgreSQL](https://www.postgresql.org/) を使っています。ただし、LAN 環境で動作させることを前提としています。インターネットサービスとしてグローバル IP の環境で動作させることは想定していません。

gblan を使うと HTTPS に対応した Web サーバーも使えるようになります。初期状態では Web ブラウザで警告がでますが、警告を表示しないように Web ブラウザを設定して使えるようになります。開発の初期段階では <http://localhost> といった URL で開発した Web アプリの動作確認をすれば十分なのですが、本格的に開発を進めていくと、HTTPS での動作確認や、Web サーバーのリバースプロキシー環境での動作確認などが必要になってきます。そういった時に gblan があれば、環境構築の手間が省略できます。

デフォルトの状態でも使えますが、実際に利用する場合は、カスタマイズしたくなる部分が多くあることでしょう。自分で改良して利用する場合は、`gblan-dev` ディレクトリーに開発環境があるので、こちらを使ってください。

## 必要なもの

gblan を動作させるには、Docker Engine、Docker Compose が必要です。利用にあたっての説明では、Docker 拡張機能、Dev Containers 拡張機能をインストールした Visual Studio Code (VS Code) が使える前提としてあります。

### Docker

- [Docker Engine](https://docs.docker.com/engine/)
- [Docker Compose](https://docs.docker.com/compose/)

これらは [Docker Desktop](https://docs.docker.com/desktop/) をインストールしてあれば使えます。
Linux では Docker Desktop をインストールしなくても Docker Engine と Docker Compose だけをインストールして使えます。
例えば、Ubuntu を使っているなら [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) を参照してインストールしておいてください。

### Visual Studio Code

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [Dev Containers 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

VS Code の拡張機能である Docker と Dev Containers を VS Code へインストールしておく必要があります。

### 動作確認済みの環境

次の環境で動作確認をしてあります。Windows や macOS でも動作するはずです。

```console
$ cat /etc/os-release 
PRETTY_NAME="Ubuntu 22.04.2 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.2 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy

$ docker version
Client: Docker Engine - Community
 Cloud integration: v1.0.31
 Version:           23.0.1
 API version:       1.42
 Go version:        go1.19.5
 Git commit:        a5ee5b1
 Built:             Thu Feb  9 19:47:01 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          23.0.1
  API version:      1.42 (minimum version 1.12)
  Go version:       go1.19.5
  Git commit:       bc3805a
  Built:            Thu Feb  9 19:47:01 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.18
  GitCommit:        2456e983eb9e37e47538f59ea18f2043c9a73640
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

$ docker compose version
Docker Compose version v2.15.1
```

## ファイルの構成

ファイルの構成は次のようになっています。

```console
gblan/
├── .gitignore
├── dc/
│   └── gblan/
│       ├── docker-compose.yml ... gblan 実行用の docker-compose 設定ファイル
│       ├── build_dc/ ... gblan 実行に必要な環境を構築するのに必要なファイルをまとめたもの
│       └── sample.env ... gblan 実行用の docker-compose 設定ファイル用環境変数ファイルのサンプル
├── gblan-dev/ ... gblan 開発用
└── README.md ... このファイル
```

この後、リポジトリをクローンもしくはアーカイブファイルを展開した `gblan` ディレクトリーのパスを `${GBLAN_DIR}` と表現します。

## 使い方

最初に「ビルド」の説明に従って、`gblan-` で始まる Docker イメージ、Docker ボリューム、Docker ネットワークを用意します。必要なら `${GBLAN_DIR}/.env` ファイルを用意します。サンプルが `${GBLAN_DIR}/sample.env` にあるので参考にしてください。

たくさんのサービスがあるので、全部を一度に把握するのは難しいはずです。まずはデフォルトの状態で使ってみて、設定を変更したい場所がある場合に、どうすれば良いかを調べていくと良いでしょう。

ビルドが済んだら、`${GBLAN_DIR}/dc/gblan/docker-compose.yml` を `Compose Up` して Docker Compose の gblan プロジェクトに含まれるサービスを起動します。ここでは初期設定のままビルドしたとして説明を続けます。その場合は、次の表の URL が使えます。

|URL|説明|
|----|----|
|<https://www.gblan.example.jp>|動作確認用 Web サイトのトップページ|
|<https://dev.gblan.example.jp>|開発用 Web サイトのトップページ|
|<https://dev.gblan.example.jp/gitbucket>|GitBucket の画面|
|<https://dev.gblan.example.jp/adminer>|Adminer の画面|

gblan.example.jp は LAN 内で利用している分には、あまり問題にはならないはずですが、可能なら自分でドメインを取得して、LAN 用のサブドメインを用意して使うのが良いです。例えば、hiro345.net というドメインを持っている場合は、lan.hiro345.net を使うようにすると良いでしょう。

### www.gblan.example.jp

動作確認用 Web サイトです。gblan-nginx コンテナーが提供する Nginx のバーチャルホストです。

<https://www.gblan.example.jp> へアクセスすると、www.gblan.example.jp という文字列が表示される画面になります。
<https://www.gblan.example.jp> 用の Web コンテンツは、Docker ボリューム gblan-nginx-html-data にあります。開発したクライアントサイドの Web アプリについて動作確認をしたい場合は、gblan-nginx-html-data 内のファイルを編集してください。

サーバーサイドの Web アプリについて動作確認したい場合は、Docker ボリューム gblan-nginx-templates-data に www.gblan.example.jp 用の Nginx の設定ファイル www.conf があります。この設定ファイルへリバースプロキシーの設定をするなどして、動作確認できるようにしてください。ただし、gblan のサービスに含まれる gblan-nginx コンテナーからサーバーサイドの Web アプリへアクセスできるようになっている必要があります。

### dev.gblan.example.jp

開発時に使用する Web サイトです。gblan-nginx コンテナーが提供する Nginx のバーチャルホストです。

<https://dev.gblan.example.jp> には、GitBucket、Adminer へのリンクが含まれています。この URL をブックマークして利用すると良いでしょう。

<https://dev.gblan.example.jp/gibtucket> へアクセスすると、GitBucket の画面になります。<https://github.com/gitbucket/gitbucket/wiki> の Installation までした状態になっています。それ以降の Configuration に説明がある初期設定をしてから使ってください。

<https://dev.gblan.example.jp/adminer> へアクセスすると、Adminer の画面になります。この画面から gblan のサービスに含まれる gblan-postgres の DB へアクセスすることができます。接続情報は `${GBLAN_DIR}/dc/gblan/docker-compose.yml` の gblan-postgres サービスに指定されている値を参照してください。

## ビルド

最初に `gblan-` で始まる Docker イメージ、Docker ボリューム、Docker ネットワークを用意します。`${GBLAN_DIR}/build_dc` ディレクトリーに gblan 実行に必要な環境を構築するのに必要なファイルがあります。具体的な作業内容は `${GBLAN_DIR}/build_dc/README.md` にあるので、その手順に従って環境を構築してください。なお、gblan では、サービスによっては、カスタムの Docker イメージをビルドします。また、ビルドが必要ない Docker イメージについては、Docker ボリュームにカスタマイズ用のファイルをコピーして使うようにしています。

ビルドには `sh` のシェルスクリプト、`docker` コマンド、`docker compose` コマンドが実行できる環境が必要です。環境としては、次のようなものが考えられます。

- a）[hiro345g/gblan\-dev\-docker](https://github.com/hiro345g/gblan-dev-docker) を使って構築した環境（[hiro345g/devnode\-desktop](https://github.com/hiro345g/devnode-desktop) の利用）
- b）Linux へ Docker CE または Docker Desktop をインストールした環境

いずれかの環境があれば、`${GBLAN_DIR}/build_dc/README.md` にある手順に従ったコマンドの実行ができます。そうすれば、必要な Docker イメージ、Docker ボリューム、Docker ネットワークが用意できます。

なお、ビルド時に a）の環境を使った場合は devnode-desktop コンテナー内からも `${GBLAN_DIR}/dc/gblan/docker-compose.yml` を `Compose Up` して gblan のサービスを起動することができます。ただし、そうした場合は、コンテナーを削除するときに devnode-desktop コンテナー内から `Compose Down` する必要が出てくるので使い勝手が悪くなります。Docker ホストで gblan のサービスを `Compose Up` するようにしましょう。

## カスタマイズ方法

構築する環境をカスタマイズする方法については、次のようにいくつかあります。

- 実行時の設定
- ビルド時の設定
- 提供されているファイルの改良

### 実行時の設定

ビルド時に環境変数を変更した場合には、それに合わせて実行時の設定を変更する必要があります。環境変数は `${GBLAN_DIR}/dc/gblan/.env` に指定します。サンプルが `${GBLAN_DIR}/dc/gblan/sample.env` にありますから、それを確認してください。

### ビルド時の設定

ビルド時に環境変数や使用するテンプレートファイルの内容を変更することができます。具体的な方法については、`${GBLAN_DIR}/dc/gblan/build_dc/<サービス名>/README.md` を参照してください。

### 提供されているファイルの改良

実行時の設定、ビルド時の設定では対応できないものについては、提供されているファイルの改良をして対応することになります。改良のための開発環境を構築する方法については、`${GBLAN_DIR}/gblan-dev/README.md` を参照してください。
