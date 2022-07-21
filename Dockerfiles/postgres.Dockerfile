FROM postgres:14-alpine

ARG VER=5.2.5
ARG URL=https://github.com/librespeed/speedtest/archive/refs/tags/${VER}.tar.gz

ADD ${URL} ./

RUN tar -xzf ${VER}.tar.gz speedtest-${VER}/results/telemetry_postgresql.sql && \
    mv speedtest-${VER}/results/telemetry_postgresql.sql /docker-entrypoint-initdb.d/telemetry_postgresql.sql && \
    chmod 775 /docker-entrypoint-initdb.d/telemetry_postgresql.sql && \
    rm -rf ${VER}.tar.gz speedtest-${VER}