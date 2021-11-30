ARG RESTY_TAG="1.19.9.1-alpine"
FROM openresty/openresty:${RESTY_TAG} AS builder

ARG NCHAN_VERSION="1.2.12"
ARG RESTY_J="1"
ARG RESTY_ADD_PACKAGE_BUILDDEPS=""
ARG RESTY_ADD_PACKAGE_RUNDEPS=""

LABEL resty_tag="${RESTY_TAG}"
LABEL nchan_version="${NCHAN_VERSION}"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

# For latest build deps, see https://github.com/openresty/docker-openresty/blob/master/alpine/Dockerfile

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        coreutils \
        curl \
        gd-dev \
        geoip-dev \
        libxslt-dev \
        linux-headers \
        make \
        perl-dev \
        readline-dev \
        zlib-dev \
        ${RESTY_ADD_PACKAGE_BUILDDEPS} \
    && apk add --no-cache \
        gd \
        geoip \
        libgcc \
        libxslt \
        zlib \
        ${RESTY_ADD_PACKAGE_RUNDEPS}

RUN RESTY_J=1 CONFARGS=$(nginx -V 2>&1 | awk -F 'arguments:' '/configure/{print $2}') RESTY_VERSION=$(nginx -V 2>&1 | awk -F '/' '/version/{print $2}') && echo ${RESTY_VERSION} ${CONFARGS} \
    && cd /tmp \
    && echo NCHAN_VERSION ${NCHAN_VERSION} \
    && wget "https://github.com/slact/nchan/archive/v${NCHAN_VERSION}.tar.gz" -O nchan.tar.gz \
    && tar -xzvf "nchan.tar.gz" \
    && curl -fSL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz -o openresty-${RESTY_VERSION}.tar.gz \
    && tar xzf openresty-${RESTY_VERSION}.tar.gz \
    && cd /tmp/openresty-${RESTY_VERSION} \
    && eval ./configure -j${RESTY_J} ${CONFARGS} --add-dynamic-module=../nchan-${NCHAN_VERSION}  \
    && make -j${RESTY_J}

FROM openresty/openresty:${RESTY_TAG}
# Extract the dynamic module NCHAN from the builder image
COPY --from=builder /usr/local/openresty/nginx/modules/ngx_nchan_module.so /usr/local/openresty/nginx/modules/ngx_nchan_module.so
RUN sed -i 's/#user/load_module\ modules\/ngx_nchan_module.so;\n#user/' /usr/local/openresty/nginx/conf/nginx.conf

