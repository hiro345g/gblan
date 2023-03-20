# build_dc

ここでは gblan が提供するサービスに対応するコンテナー用の Docker イメージや Docker ボリュームの用意をするために必要なファイルが置いてあります。

|サービス名|説明|
|----|----|
|gblan-dns|ネームサーバー|
|gblan-gitbucket|Gitリモートリポジトリー|
|gblan-mkcert|自己認証局|
|gblan-nginx|Web サーバー|
|gblan-share|共用 Docker ボリューム管理用|
|gblan-sshd|SSH サーバー|
|gblan-util|ユーティリティーツール|

## ファイル構成

各サービスをビルドするためのファイルが用意されています。

```text
├── README.md ... このファイル
├── gblan-dns/
├── gblan-gitbucket/
├── gblan-mkcert/
├── gblan-nginx/
├── gblan-share/
├── gblan-sshd/
├── gblan-util/
└── script/ ... スクリプト (`${GBLAN_DEV_DIR}/README.md に説明`)
```

各サービス用ディレクトリーは下記のファイル構成を基本としています。

```text
<サービス名>
├── .gitignore
├── README.md
├── build/
│   ├── Dockerfile
│   └── docker-compose.yml
├── docker-compose.yml
├── sample/
│   ├── Corefile
│   └── gblan_example_jp_hosts
└── script/
    ├── build.sh
    └── clean.sh
```
