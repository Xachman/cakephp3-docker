FROM php:7.1-apache

MAINTAINER xachman

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++ fontconfig libfontconfig1 libxrender1 libxext6 xvfb nodejs wget libxml2-dev && \
docker-php-ext-install mbstring intl simplexml pdo_mysql &&  \
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
mv composer.phar /usr/local/bin/composer && \
curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -P /tmp/ && \
tar xvf /tmp/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -C /opt/ && \
ln -s /opt/wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf && \
rm -Rf /tmp/*

RUN rm -rf /var/www/* && sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/webroot/g' /etc/apache2/sites-available/000-default.conf


CMD /var/www/bin/cake migrations migrate; apache2-foreground