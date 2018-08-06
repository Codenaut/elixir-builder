FROM erlang:21.0.4

MAINTAINER jalp@codenaut.com
ENV UPDATED_AT "2018-08-06 16.30"

# elixir expects utf8
ENV ELIXIR_VERSION="v1.7.2" \
	LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA256="3258eca6b5caa5e98b67dd033f9eb1b0b7ecbdb7b0f07c111b704700962e64cc" \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean


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
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV LC_CTYPE C.UTF-8

CMD ["mix", "release"]
