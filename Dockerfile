FROM elixir:1.12

WORKDIR /app/src
ENTRYPOINT ["/app/entrypoint.sh"]
RUN apt-get update && apt-get install -y exiftool