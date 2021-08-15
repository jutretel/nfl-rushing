FROM elixir:1.11.4

RUN mix do local.hex --force, local.rebar --force

RUN apt-get update
RUN apt-get install -y inotify-tools
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get -y install nodejs

COPY docker/ /usr/local/bin

CMD ["/nfl/docker/entrypoint.sh"]
