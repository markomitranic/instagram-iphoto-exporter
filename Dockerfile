FROM elixir:1.12

WORKDIR /app/src
ENTRYPOINT ["/app/entrypoint.sh"]