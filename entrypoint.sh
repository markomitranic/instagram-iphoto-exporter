#!/bin/sh

set -e

mix local.hex --force && mix local.rebar --force
echo "[Success] Dev container up."
tail -f /dev/null