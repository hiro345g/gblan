# gblan-dns

gblan-net で使用するコンテナーについて、`gblan.example.jp` のドメインのホストとしてアクセスできるようにします。
Docker イメージは [coredns/coredns](https://hub.docker.com/r/coredns/coredns/) を使っています。
`sample/Corefile`、`sample/gblan_example_jp_hosts` を参考にして `build/` に `Corefile` と `gblan_example_jp_hosts` を用意します。
これらのファイルが `build/` にない場合は、`sample/` のものを使ってビルドします。
