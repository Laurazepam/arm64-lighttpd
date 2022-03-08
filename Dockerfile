#
# lighttpd Dockerfile
#
# https://github.com/Laurazepam/arm64-lighttpd
#

# Pull base image.
FROM arm64v8/node:current-alpine3.15

ENV LIGHTTPD_VER=1.4.64-r0 \
    LIGHTTPD_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/lighttpd.conf \
    MODULES_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/modules.conf \
    ACCESS_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/conf.d/access_log.conf \
    MIME_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/conf.d/mime.conf \
    DIRLIST_CONF=https://redmine.lighttpd.net/projects/lighttpd/repository/14/revisions/master/raw/doc/config/conf.d/dirlisting.conf

RUN apk add --no-cache \
        lighttpd=${LIGHTTPD_VER} \
        lighttpd-mod_auth=${LIGHTTPD_VER} \
        curl \
    && rm -rf /var/cache/apk/*

RUN curl ${LIGHTTPD_CONF} --create-dirs -o /mytemp/lighttpd.conf \
    && curl ${MODULES_CONF} -o /mytemp/modules.conf \
    && curl ${ACCESS_CONF} --create-dirs -o /mytemp/conf.d/access_log.conf \
    && curl ${MIME_CONF} -o /mytemp/conf.d/mime.conf \
    && curl ${DIRLIST_CONF} -o /mytemp/conf.d/dirlisting.conf \
    && chown lighttpd /mytemp/* \
    && chown lighttpd /mytemp/conf.d/* \
    && sed -i '164s/^/#/' /mytemp/lighttpd.conf \
    && apk del curl

COPY dir/start /usr/local/bin/
COPY dir/index.html /mytemp/index.html

RUN chmod +x /usr/local/bin/start

VOLUME /etc/lighttpd \
       /srv/www

CMD ["start"]

EXPOSE 80