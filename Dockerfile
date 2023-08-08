FROM php:8.0-apache-bullseye
WORKDIR /var/www/glpi
COPY conf.ini               /usr/local/etc/php/conf.d/
COPY glpi.localhost.conf    /etc/apache2/sites-available/
RUN apt-get update && apt-get install -y exiftool libbz2-dev libicu-dev libldap2-dev libpng-dev libssl-dev libzip-dev
RUN apt-get autoremove && apt-get autoclean
RUN docker-php-ext-install  exif intl mysqli gd ldap opcache phar bz2 zip
RUN docker-php-ext-enable   exif intl mysqli gd ldap opcache phar bz2 zip
ADD https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz /tmp/
RUN cd /tmp \
    && tar -zxf glpi-10.0.9.tgz -C /tmp/ \
    && mv /tmp/glpi /var/www/. \
    && rm -rf glpi-10.0.9.tgz \
    && chown -R www-data:www-data /var/www/glpi \
    && find /var/www/glpi -type d -exec chmod 755 {} \; \
    && find /var/www/glpi -type f -exec chmod 644 {} \;
RUN a2enmod rewrite && a2dissite 000-default && a2ensite glpi.localhost
EXPOSE 80