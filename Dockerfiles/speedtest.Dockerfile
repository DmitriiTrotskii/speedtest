ARG VER=5.2.5

FROM alpine:latest

ARG VER
ARG URL=https://github.com/librespeed/speedtest/archive/refs/tags/${VER}.tar.gz

ADD ${URL} ./

RUN tar -xzf ${VER}.tar.gz -C ./

FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql pdo_pgsql pgsql

RUN mkdir -p /speedtest/

ARG VER
ARG SRC=/speedtest-${VER}

COPY --from=0 ${SRС}/backend/ /speedtest/backend

COPY --from=0 ${SRС}/results/*.php /speedtest/results/
COPY --from=0 ${SRС}/results/*.ttf /speedtest/results/

COPY --from=0 ${SRС}/*.js /speedtest/
COPY --from=0 ${SRС}/favicon.ico /speedtest/

COPY --from=0 ${SRС}/docker/servers.json /servers.json

COPY --from=0 ${SRС}/docker/*.php /speedtest/
COPY --from=0 ${SRС}/docker/entrypoint.sh /

ENV TITLE=LibreSpeed
ENV MODE=standalone
ENV PASSWORD=password
ENV TELEMETRY=false
ENV ENABLE_ID_OBFUSCATION=false
ENV REDACT_IP_ADDRESSES=false
ENV WEBPORT=80

EXPOSE 80
CMD ["bash", "/entrypoint.sh"]