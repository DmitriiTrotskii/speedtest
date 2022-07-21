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

ARG VER=5.2.5
ARG URL=https://github.com/librespeed/speedtest/archive/refs/tags/${VER}.tar.gz

ADD ${URL} ./

RUN tar -xzf ${VER}.tar.gz \
    speedtest-${VER}/backend/ \
    --wildcards speedtest-${VER}/results/*.php \
    --wildcards speedtest-${VER}/results/*.ttf \
    --wildcards speedtest-${VER}/*.js \
    speedtest-${VER}/favicon.ico \
    speedtest-${VER}/docker/servers.json \
    --wildcards speedtest-${VER}/docker/*.php \
    speedtest-${VER}/docker/entrypoint.sh && \
    mv speedtest-${VER}/docker/*.php speedtest-${VER}/ && \
    mv speedtest-${VER}/docker/entrypoint.sh / && \
    mv speedtest-${VER}/docker/servers.json speedtest-${VER}/ && \
    rm -rf speedtest-${VER}/docker && \
    rm -f ${VER}.tar.gz && \
    mv speedtest-${VER} /speedtest

ENV TITLE=LibreSpeed
ENV MODE=standalone
ENV PASSWORD=password
ENV TELEMETRY=false
ENV ENABLE_ID_OBFUSCATION=false
ENV REDACT_IP_ADDRESSES=false
ENV WEBPORT=80

EXPOSE 80
CMD ["bash", "/entrypoint.sh"]

# workflow test