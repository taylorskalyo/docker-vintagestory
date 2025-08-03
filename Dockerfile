# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.19 AS buildstage
############## build stage ##############

# package version
ARG VINTAGESTORY_RELEASE

RUN \
  echo "**** install build packages ****" && \
  apk add -U --update --no-cache \
    dotnet7-runtime \
    gcompat \
    jq \
    sqlite-libs \
    tar

WORKDIR /tmp/vintagestory/server
RUN \
  echo "**** download vintagestory ****" && \
  curl -L "https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_${VINTAGESTORY_RELEASE}.tar.gz" -o server.tar.gz && \
  tar -xzf server.tar.gz && \
  rm server.tar.gz && \
  cp /usr/lib/libsqlite3.so.0 Lib/libe_sqlite3.so

# Assume all packages are needed at runtime
RUN \
  echo "**** determine runtime packages ****" && \
  cat /etc/apk/world \
    >> /tmp/vintagestory/packages

############## runtime stage ##############

FROM ghcr.io/linuxserver/baseimage-alpine:3.19

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="taylorskalyo"

# copy files from build stage
COPY --from=buildstage /tmp/vintagestory/server /server/
COPY --from=buildstage /tmp/vintagestory/packages /packages

RUN \
  echo "**** install runtime packages ****" && \
  RUNTIME_PACKAGES=$(echo $(cat /packages)) && \
  apk add -U --update --no-cache \
    ${RUNTIME_PACKAGES} && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 42420

VOLUME /config
