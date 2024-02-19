FROM debian:bullseye-slim AS base

ENV LC_ALL C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
ARG http_proxy=""
ARG https_proxy=""

ARG COMPOSER_SHA256="1ffd0be3f27e237b1ae47f9e8f29f96ac7f50a0bd9eef4f88cdbe94dd04bfff0"

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get -q update && \
    apt-get install -y eatmydata  && \
    eatmydata -- apt-get install -y apt-transport-https ca-certificates && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*

COPY ./provisioning/sources.list /etc/apt/sources.list
COPY ./provisioning/debsury.gpg /usr/share/keyrings/deb.sury.org-php.gpg

RUN apt-get -qq update && \
    eatmydata -- apt-get -qy install \
        apache2 libapache2-mod-php8.2 \
        curl \
        git-core \
        netcat \
        jq \
        php8.2 php8.2-cli php8.2-curl php8.2-xml php8.2-mysql php8.2-mbstring php8.2-bcmath php8.2-zip php8.2-mysql php8.2-sqlite3 php8.2-opcache php8.2-xml php8.2-xsl php8.2-intl php8.2-xdebug php8.2-apcu php8.2-grpc php8.2-protobuf \
        zip unzip && \
    rm -Rf /var/lib/apt/lists/* && \
    a2enmod headers rewrite deflate php8.2 && \
    rm /etc/apache2/conf-enabled/other-vhosts-access-log.conf /etc/apache2/conf-enabled/serve-cgi-bin.conf && \
    update-alternatives --set php /usr/bin/php8.2

COPY ./provisioning/php.ini /etc/php/8.2/apache2/conf.d/local.ini
COPY ./provisioning/php.ini /etc/php/8.2/cli/conf.d/local.ini

RUN echo GMT > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata \
    && mkdir -p "/var/log/apache2" \
    && ln -sfT /dev/stderr "/var/log/apache2/error.log" \
    && ln -sfT /dev/stdout "/var/log/apache2/access.log" 

RUN curl -so /usr/local/bin/composer https://getcomposer.org/download/2.7.1/composer.phar && chmod 755 /usr/local/bin/composer

# 0844c3dd85bbfa039d33fbda58ae65a38a9f615fcba76948aed75bf94d7606ca  /usr/local/bin/composer
RUN echo "${COMPOSER_SHA256}  /usr/local/bin/composer" | sha256sum --check


CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80
