#
# lighttpd Dockerfile
#
# https://github.com/Laurazepam/arm64-lighttpd
#

# Pull base image.
FROM alpine:latest

# Define for readability
ENV LIGHTTPD_VER=1.4.64-r0 \
    LIGHTTPD_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/lighttpd.conf \
    MODULES_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/modules.conf \
    ACCESS_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/conf.d/access_log.conf \
    MIME_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/conf.d/mime.conf \
    DIRLIST_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/conf.d/dirlisting.conf \
    README=https://raw.githubusercontent.com/Laurazepam/arm64-lighttpd/main/README.md \
    PANDOC_DOWN=https://github.com/jgm/pandoc/releases/download/2.17.1.1/pandoc-2.17.1.1-linux-arm64.tar.gz

WORKDIR /temp

RUN apk add --no-cache \
        lighttpd=${LIGHTTPD_VER} \
        lighttpd-mod_auth=${LIGHTTPD_VER} \
        curl \
        tar \
    && rm -rf /var/cache/apk/* \
    && curl -L ${PANDOC_DOWN} -o pandoc.tar.gz \
    && tar xvzf pandoc.tar.gz --strip-components 1 \
    && rm -rf pandoc.tar.gz

RUN curl ${LIGHTTPD_CONF} --create-dirs -o /mytemp/lighttpd.conf \
    && curl ${MODULES_CONF} -o /mytemp/modules.conf \
    && curl ${ACCESS_CONF} --create-dirs -o /mytemp/conf.d/access_log.conf \
    && curl ${MIME_CONF} -o /mytemp/conf.d/mime.conf \
    && curl ${DIRLIST_CONF} -o /mytemp/conf.d/dirlisting.conf \
    && ./bin/pandoc ${README} -f markdown -t html -s -o /mytemp/index.html --metadata title="Congratulations!" \
    && chown lighttpd /mytemp/* \
    && chown lighttpd /mytemp/conf.d/* \
    && sed -i '164s/^/#/' /mytemp/lighttpd.conf \
    && apk del \
        curl \
    && rm -rf *

COPY start /usr/local/bin/start

RUN chmod +x /usr/local/bin/start

VOLUME /etc/lighttpd \
       /srv/www

CMD ["start"]

EXPOSE 80
