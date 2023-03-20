# gblan-gibtucket

Docker イメージ [gitbucket/gitbucket](https://hub.docker.com/r/gitbucket/gitbucket/) を使っています。
また、Docker ボリューム gblan-dev-gitbucket-data の初期化と gitbucket.conf、database.conf の設定ファイル追加をしています。
`sample/gitbucket.conf`、`sample/database.conf` を参考にして `build/gitbucket.conf`、`build/database.conf` を用意してください。これらのファイルが `build/` にない場合は、`sample/` のものを使ってビルドします。

プラグインについては、`script/download_plugin.sh` を使って gblan-dev-gitbucket-data へダウンロードしています。プラグインを追加したい場合は、このスクリプトへ処理を追加してください。

## gitbucket.conf

`sample/gitbucket.conf` には dev.gblan.example.jp ドメインでの URL や SSH の設定をしてあります。
`sample/gitbucket.localhost.conf` では、動作確認時に使う URL や SSH の設定をしてあります。
デフォルトから変更してあるものは、次の4つです。

```text
ssh.publicAddress.port=12222
base_url=http\://localhost\:18080/gitbucket
ssh.bindAddress.port=29418
ssh.bindAddress.host=gblan-dev-gitbucket
```

## database.conf

`sample/database.conf` では、gblan-postgres コンテナーへの接続情報を指定しています。DB 接続情報については、gblan-postgres コンテナーを起動するときに、`docker-compose.yml` と対応する `.env` ファイルに指定した値が使われます。もし、`.env` ファイルがない場合は、`docker-compose.yml` に記載されているものが使われます。それと合わせた値にしておく必要があります。

なお、ここで間違えた `database.conf` のものを使ってしまっても、後で gblan-dev-gitbucket-data 内のファイルを変更して対応できます。

## docker-compose.yml

コンテナー起動確認用の `docker-compose.yml` を用意してあります。環境変数をカスタマイズする場合は、`sample.env` を `.env` へコピーして編集します。なお、環境変数を変更した場合は、`database.conf` も確認して必要なら編集してください。
