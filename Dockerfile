FROM php:7.1-apache
RUN apt-get update
RUN apt-get install -y mariadb-client zip libxml2-dev libpng-dev
RUN docker-php-ext-install mysqli simplexml mbstring gd
ADD https://download.simplemachines.org/index.php/smf_2-1-rc4_install.tar.gz /var/www/
ADD https://download.simplemachines.org/index.php/smf_2-1-rc4_spanish_es.tar.gz /var/www/
RUN cd /var/www/html; tar xfz ../smf_2-1-rc4_install.tar.gz; tar xfz ../smf_2-1-rc4_spanish_es.tar.gz; rm ../smf_2-1-rc4_install.tar.gz; rm ../smf_2-1-rc4_spanish_es.tar.gz
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD smf.conf /etc/apache2/sites-enabled/
WORKDIR /var/www/html
RUN chmod -R 777 attachments avatars cache Packages Packages/installed.list Smileys Themes agreement.txt Settings.php Settings_bak.php
RUN chown -R www-data:www-data .
RUN service apache2 stop
ADD start.sh /

EXPOSE 80
ENV SMF_BOARD_URL $SMF_BOARD_URL
CMD bash /start.sh
