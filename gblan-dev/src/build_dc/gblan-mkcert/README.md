# gblan-mkcert

自己認証局によるサーバー証明書を作成するためのものです。
ここでは [FiloSottile/mkcert](https://github.com/FiloSottile/mkcert) を使っています。
[ubuntu \- Official Image](https://hub.docker.com/_/ubuntu) をベースとして、`/script` にいくつかのスクリプトをコピーした後に、mkcert のインストールをした Docker イメージを作成しています。

次の2つの Docker ボリュームを作成しています。

- gblan-dev-mkcert-root
- gblan-dev-mkcert-keys-data

gblan-dev-mkcert-root ボリュームには CA の情報が保存されます。gblan-dev-mkcert-keys-data ボリュームには作成したサーバー証明書用の情報が保存されます。

バックアップ用スクリプト `backup.sh` とリストア用スクリプト `restore.sh` があり、これらは gblan-dev-share-data ボリュームを利用するようになっています。
