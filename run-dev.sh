#!/bin/sh

docker build \
    -f Dockerfile \
    -t instagram-iphoto-exporter:local .

docker run \
    -v $(pwd):/app \
    --name instagram_iphoto_exporter \
    -it --rm instagram-iphoto-exporter:local
