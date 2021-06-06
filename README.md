

```
./run-dev.sh

docker exec -ti instagram_iphoto_exporter bash

mix deps.get
mix deps.compile
mix run insta_iphoto.exs
```