# taylorskalyo/vintagestory

Docker image for Vintage Story based on [linuxserver.io's alpine base image](https://github.com/linuxserver/docker-baseimage-alpine).

> [!WARNING]
> At the moment I have no plans to maintain this image beyond version 1.20.12. If you need older/newer versions consider using one of the other available images. [VSDS](https://github.com/XurxoMF/vsds) seems to have several versions available (though I have not tried any of them).

## Usage

### docker-compose (recommended)

```
---
services:
  vintagestory:
    image: ghcr.io/taylorskalyo/vintagestory
    container_name: vintagestory
    environment:
      PUID: 1000
      PGID: 1000
      STARTUP_COMMANDS: "/op <your-user>"
      PLAYERS_WHITELIST: "<your-user> <another-user>"
      SERVER_PASSWORD: "<a-secure-password>"
      MOD_URLS: "
      <url-for-mod-zip-file>
      <url-for-mod-zip-file>
      "
    volumes:
      - <path-to-config>:/config
    ports:
      - 42420:42420
    restart: unless-stopped
```

## Parameters

Containers are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 42420` | Vintage Story port |
| `-e PUID=1000` | For UserID - see below for explanation |
| `-e PGID=1000` | For GroupID - see below for explanation |
| `-e TZ=Etc/UTC` | Specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e STARTUP_COMMANDS=` | Run a command when server starts. For example, players without access to the server console can op themselves. Can run multiple commands by separating them with linebreaks. See official [docs](https://wiki.vintagestory.at/Server_Config) |
| `-e SERVER_PASSWORD=` | If not empty, requires a password for players to log in |
| `-e PLAYERS_WHITELIST=` | By default Vintage Story only allows whitelisted players to join |
| `-e MOD_URLS=` | Download mods from the given URLs before starting the server |
| `-v /config` | Persistent config files |
