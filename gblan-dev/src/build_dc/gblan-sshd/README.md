# gblan-sshd

OpenSSH サーバーを動作させるコンテナー用の Docker イメージを作成します。
デフォルトでは user001 ユーザーを用意しています。

作成するユーザーについてカスタマイズする場合は、`build/.env` ファイルを用意します。
サンプルが `sample/sample.env` にあるので、参考にして作成してください。

`/etc/ssh/sshd_config` をカスタマイズするために、`build/sshd_config` を用意してください。サンプルが `sample/sshd_config` にあります。`build/sshd_config` がない場合は、サンプルのものを使います。

次の Docker ボリュームの初期化もしています。

- gblan-dev-sshd-etc-ssh-data
- gblan-dev-sshd-home-data

それぞれ、`/etc/ssh/` と `/home/` にマウントして使います。
