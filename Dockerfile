FROM elixir:1.6.4

MAINTAINER jalp@codenaut.com
ENV UPDATED_AT "2018-03-21 12:49"

WORKDIR /tmp
RUN apt-get clean && apt-get update && apt-get install -y locales && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    locale-gen en_US.UTF-8 

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

VOLUME /build
WORKDIR /build

ENV MIX_ENV prod
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

CMD ["mix", "release"]
