# gblan-dev

gblan の開発では gblan-dev リポジトリーを用意して作業します。ここでは、各パスについて、次の表のように表記するとします。

|表記|例|説明|
|----|----|----|
|`${GBLAN_DIR}`|/home/node/repo/gblan|gblan リポジトリー|
|`${GBLAN_DEV_DIR}`|/home/node/repo/gblan/gblan-dev|gblan 開発用|
|`${GBLAN_DEV_DOCKER_DIR}`|/home/node/repo/gblan-dev-docker|gblan 開発用 Docker のリポジトリー|

ここでは、`${GBLAN_DEV_DOCKER_DIR}/README.md` の手順に従って、gblan リポジトリーを作成して開発しているとして説明します。コマンドは、`${GBLAN_DEV_DIR}` をカレントとしている前提です。

## サービス用リソースの用意

gblan の開発をする場合は、最初にサービスで使用するリソースの Docker ネットワークと Docker ボリュームの用意が必要です。

```console
sh src/build_dc/gblan-share/script/init.sh
```

これらを削除して元に戻す場合は下記のコマンドを実行します。

```console
sh src/build_dc/gblan-share/script/clean.sh
```

## サービス

gblan の開発では、サービス毎に作業をすると良いでしょう。gblan サービスとしては下記を用意してあります。各サービスで使用する Docker イメージ、Docker ボリュームのビルドについては、対応するディレクトリーにある `README.md` を参照してください。

- gblan-dns
- gblan-gitbucket (gblan-postgres, gblan-adminer を含む)
- gblan-mkcert
- gblan-nginx
- gblan-sshd
- gblan-share

## ビルド

gblan の各サービスの開発をしたら、ビルドして想定している Docker イメージや Docker ボリュームが用意できるか確認します。ここでは、`${GBLAN_DEV_DIR}/` をカレントディレクトリーにしているとします。

```console
cd ${GBLAN_DEV_DIR}/
```

開発した gblan-dev をビルドするには `${GBLAN_DEV_DIR}/src/build_dc/script/build.sh` を実行します。

```console
sh ./src/build_dc/script/build.sh
```

ビルドした Docker イメージや Docker ボリュームを削除するには `clean.sh` を実行します。

```console
sh ./src/build_dc/script/clean.sh
```

なお、Docker イメージや Docker ボリュームをビルドするときは、基本的には `<サービス用ディレクトリ>/sample/` のファイルを `<サービス用ディレクトリ>/build/` にコピーしたものを使います。そうやって作成した `<サービス用ディレクトリ>/build/` 内のファイルを削除する場合は、`clean_sample.sh` を実行します。

```console
sh ./src/build_dc/script/clean_sample.sh
```

サービス単位でのビルドもできます。

```console
sh ./src/build_dc/<サービス名>/script/build.sh
```

サービス単位での削除もできます。

```console
sh ./src/build_dc/<サービス名>/script/clean.sh
```

## デプロイ前の動作確認

gblan の各サービスの開発をしたら、デプロイをする前に動作確認します。ここで作成したものは、Docker Compose の gblan-dev プロジェクトのサービスとして起動するので gblan とは別に動作します。ただし、コンテナーへの転送ポート番号などがぶつかっているので、gblan のプロジェクトのサービスを動作させていると、動作させることはできません。注意しましょう。

動作確認方法には主に2つの方法があります。

- devnode-desktop コンテナーを使う場合
- Docker ホストを使う場合

ここでは、devnode-desktop コンテナーを使う方法について説明します。devnode-desktop コンテナーを使う方法がわかれば、Docker ホストを使う場合にも応用できます。

### devnode-desktop コンテナーを使う場合の動作確認

devnode-desktop コンテナーの Web ブラウザへ自己認証局の証明書を登録する必要があるので、最初に用意しておきます。
Web ブラウザへ登録する自己認証局の証明書は `gblan-dev-nginx:/etc/nginx/keys/certs/rootCA.pem` にあるので、Docker ホストを経由して devnode-desktop コンテナーへコピーします。具体的には次のコマンドを実行します。

```console
docker compose -p gblan-dev cp gblan-dev-nginx:/etc/nginx/keys/certs/rootCA.pem .
docker compose -p devnode-desktop cp rootCA.pem devnode-desktop:/home/node/repo/gblan-dev-mkcert-CA.pem
rm rootCA.pem
```

次に Docker ホストで Web ブラウザを開いて、devnode-desktop コンテナーの noVNC の URL である <http://localhost:6080> へアクセスして、動作確認をしてみましょう。
devnode-desktop コンテナーを使う場合は使用している Docker ネットワークが、gblan-net ではないので Docker ホスト経由でのアクセスが必要です。

手軽なのは、devnode-desktop コンテナーのターミナルで `/etc/hosts` に www.gblan.example.jp と dev.gblan.example.jp のエントリーの追加をする方法です。
bash を起動して次のコマンドを実行します。

```console
ip=$(ip a|grep inet|grep -v 127|awk '{print $2}'|sed 's%2/16%1%')
echo "" | sudo tee -a /etc/hosts
echo "${ip}    www.gblan.example.jp dev.gblan.example.jp" | sudo tee -a /etc/hosts
```

これで、`/etc/hosts` にエントリー追加できました。`cat` コマンドでを確認すると、次のようになります。

```console
node ➜ ~ $ cat /etc/hosts
127.0.0.1       localhost
（略）
172.23.0.2      devnode-desktop
172.23.0.1      www.gblan.example.jp dev.gblan.example.jp
```

IP アドレスは環境によって変わりますが、 devnode-desktop と同じネットワークから見るためには、同じネットワークの IP アドレスにすれば良いです。ここでは devnode-desktop が 172.23.0.2 なので、最後の 2 の値を 1 にして、www.gblan.example.jp dev.gblan.example.jp の IP アドレスとして指定しています。

Chromium や Firefox を起動して自己認証局の証明書を登録します。

Chromium では <chrome://settings/certificates> を開き、「認証局」タブを開きます。「インポート」をクリックして、`/home/node/repo/gblan-dev-mkcert-CA.pem` をインポートします。Web サイトで使うので、Web だけチェックすれば良いです。

Firefox では <about:preferences#privacy> を開き、「プライバシーとセキュリティ」をクリックします。「証明書」の欄の「証明書を表示...」をクリックし、「証明書マネージャー」の画面を表示します。「認証局証明書」タブをクリックし、「インポート...」をクリックして `/home/node/repo/gblan-dev-mkcert-CA.pem` をインポートします。Web サイトで使うので、Web だけチェックすれば良いです。

それから、Chromium で <https://dev.gblan.example.jp/> と <https://www.gblan.example.jp/> へアクセスします。これで動作確認ができます。GitBucket や Adminer についても動作確認ができます。CoreDNS については、bash で `dig` コマンドなどを使って確認できます。

Web ブラウザの設定は devnode-desktop コンテナーを削除すると消えてしまいます。`devnode-desktop:/home/node/repo/` へ保存しておけば、次回の起動時に再利用できます。

```console
node ➜ ~ $ cp -a .mozilla/ repo/
node ➜ ~ $ cp -a .config/chromium repo/
```

リストアするには、devnode-desktop コンテナー起動直後に、bash を起動して、下記のようにコマンド実行します。

```console
cp -a ~/repo/.mozilla/ ~/
cp -a ~/repo/chromium ~/.config/
```

## デプロイ

ここでは、`${GBLAN_DEV_DIR}/` をカレントディレクトリーにしているとします。

```console
cd ${GBLAN_DEV_DIR}/
```

デプロイする前には「ビルド」に従ってビルドします。また、「デプロイ前の動作確認」に従い、動作確認をしてからデプロイします。
動作確認ができたら、`${GBLAN_DEV_DIR}/src/build_dc/script/create_dist.sh` スクリプトを使って `dist` ディレクトリーにデプロイ用のファイルを作成します。

```console
sh ./src/build_dc/script/create_dist.sh
```

内容を確認して問題なければ、`${GBLAN_DEV_DIR}/src/build_dc/script/deploy.sh` スクリプトを使って `${GBLAN_DIR}/dc/gblan` へ反映します。
これに含まれるファイルを、実行する環境へコピーして使います。devnode-desktop 環境（Linux 環境）であれば、下記のようにします。

```console
sh ./src/build_dc/script/deploy.sh
```

gblan-dev-docker を使って devnode-desktop コンテナーを使う開発環境を使っている場合は、Docker ホストで `${GBLAN_DIR}/dc` ディレクトリーをカレントとして、devnode-desktop コンテナーからファイルをコピーします。すでに `${GBLAN_DIR}/dc/gblan` ディレクトリーがある場合は削除するか別名にしておきます。
具体的には次のようにコマンドを実行します。

```console
cd ${GBLAN_DIR}/dc/
docker compose -p devnode-desktop cp devnode-desktop:/home/node/repo/gblan/gblan-dev/src/build_dc/script/deploy.sh
docker compose -p devnode-desktop cp devnode-desktop:/home/node/repo/gblan/dc/gblan gblan
```
