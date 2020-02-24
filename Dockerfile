FROM alpine:latest

LABEL Description="Dockerized MiKTeX, Alpine Linux latest" Vendor="Christian Schenk" Version="2.9.7300"

RUN    apk update \
    && apk add \
           ca-certificates \
           ghostscript \
           gnupg \
           gosu \
           make \
           perl \
           curl \
# 安装主机当前目录下 miktex.apk
    && apk add --allow-untrusted \
          build-miktex/apk/miktex*.apk

RUN    miktexsetup finish \
    && initexmf --admin --set-config-value=[MPM]AutoInstall=1 \
    && mpm --admin --update-db \
    && mpm --admin \
           --install amsfonts \
           --install biber-linux-x86_64 \
    && initexmf --admin --update-fndb

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

ENV MIKTEX_USERCONFIG=/miktex/.miktex/texmfs/config
ENV MIKTEX_USERDATA=/miktex/.miktex/texmfs/data
ENV MIKTEX_USERINSTALL=/miktex/.miktex/texmfs/install

WORKDIR /miktex/work

CMD ["bash"]