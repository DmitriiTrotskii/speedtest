ARG VER=5.2.5

FROM alpine:latest

ARG VER
ARG URL=https://github.com/librespeed/speedtest/archive/refs/tags/${VER}.tar.gz

ADD ${URL} ./

RUN tar -xzf ${VER}.tar.gz -C ./

FROM postgres:14-alpine

ARG VER
ARG SRC=/speedtest-${VER}

COPY --from=0 ${SRС}/results/telemetry_postgresql.sql /docker-entrypoint-initdb.d
RUN chmod 775 /docker-entrypoint-initdb.d/telemetry_postgresql.sql