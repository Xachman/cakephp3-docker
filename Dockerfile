FROM php:7.3-apache

MAINTAINER xachman
ARG build_packages='\
zlib1g-dev \
libicu-dev \
g++ \
fontconfig \
libfontconfig1 \
libxrender1 \
libxext6 \
xvfb \
wget \
libxml2-dev \
libzip-dev'

RUN apt-get update && apt-get install -y ${build_packages} && \
docker-php-ext-install mbstring intl simplexml pdo_mysql zip &&  \
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -P /tmp/ && \
tar xvf /tmp/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -C /opt/ && \
ln -s /opt/wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf && \
rm -Rf /tmp/* && \
a2enmod rewrite

WORKDIR \var\www

RUN rm -rf /var/www/* && sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/webroot/g' /etc/apache2/sites-available/000-default.conf

COPY apache2.conf /etc/apache2

CMD apache2-foreground
