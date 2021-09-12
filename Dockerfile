FROM php:7.1-apache
RUN apt-get update
RUN bash -c 'debconf-set-selections <<< "mariadb-server mysql-server/root_password password rootpass" ' \
	&& bash -c 'debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password rootpass" '
RUN apt-get install -y mariadb-server mariadb-client zip libxml2-dev libpng-dev
RUN docker-php-ext-install mysqli simplexml mbstring gd
RUN service mysql start \
	&& mysql --password=rootpass -e "create database smf;grant all privileges on smf.* to 'smf'@'localhost' identified by 'smfpass' with grant option;" \
	&& service mysql stop
ADD http://download.simplemachines.org/index.php/smf_2-0-18_install.tar.gz /var/www/
RUN mkdir /var/www/smf; cd /var/www/smf; tar xfz ../smf_2-0-18_install.tar.gz; rm ../smf_2-0-18_install.tar.gz
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD smf.conf /etc/apache2/sites-enabled/
WORKDIR /var/www/smf
RUN chmod 777 attachments avatars cache Packages Packages/installed.list Smileys Themes agreement.txt Settings.php Settings_bak.php
RUN chown -R www-data:www-data .
RUN service mysql start \
	&& service apache2 start \
	&& curl "http://localhost/" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: en-CA,en;q=0.5" --compressed -H "Cookie: SMFCookie956=a"%"3A4"%"3A"%"7Bi"%"3A0"%"3Bi"%"3A1"%"3Bi"%"3A1"%"3Bs"%"3A40"%"3A"%"223136fd2ddd425cde6804e372d403dfce721c1527"%"22"%"3Bi"%"3A2"%"3Bi"%"3A1714619299"%"3Bi"%"3A3"%"3Bi"%"3A0"%"3B"%"7D; X-Handle-Time="%"7B"%"22start"%"22"%"3A1520274967.610455036163330078125"%"2C"%"22end"%"22"%"3A1520274967.938497066497802734375"%"2C"%"22time"%"22"%"3A0.32804203033447265625"%"7D; PHPSESSID=648388de8572abb23c0b91a9672209e4" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache" > /dev/null \
	&& curl "http://localhost/install.php?step=0" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: en-CA,en;q=0.5" --compressed -H "Referer: http://localhost/install.php" -H "Content-Type: application/x-www-form-urlencoded" -H "Cookie: SMFCookie956=a"%"3A4"%"3A"%"7Bi"%"3A0"%"3Bi"%"3A1"%"3Bi"%"3A1"%"3Bs"%"3A40"%"3A"%"223136fd2ddd425cde6804e372d403dfce721c1527"%"22"%"3Bi"%"3A2"%"3Bi"%"3A1714619299"%"3Bi"%"3A3"%"3Bi"%"3A0"%"3B"%"7D; X-Handle-Time="%"7B"%"22start"%"22"%"3A1520274967.610455036163330078125"%"2C"%"22end"%"22"%"3A1520274967.938497066497802734375"%"2C"%"22time"%"22"%"3A0.32804203033447265625"%"7D; PHPSESSID=648388de8572abb23c0b91a9672209e4" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data "contbutt=Continue" > /dev/null \
	&& curl "http://localhost/install.php?step=2" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: en-CA,en;q=0.5" --compressed -H "Referer: http://localhost/install.php?step=0" -H "Content-Type: application/x-www-form-urlencoded" -H "Cookie: SMFCookie956=a"%"3A4"%"3A"%"7Bi"%"3A0"%"3Bi"%"3A1"%"3Bi"%"3A1"%"3Bs"%"3A40"%"3A"%"2259e4153dc9df79cf107d608cbafa8b6f334e14ec"%"22"%"3Bi"%"3A2"%"3Bi"%"3A1714614217"%"3Bi"%"3A3"%"3Bi"%"3A0"%"3B"%"7D; X-Handle-Time="%"7B"%"22start"%"22"%"3A1520274967.610455036163330078125"%"2C"%"22end"%"22"%"3A1520274967.938497066497802734375"%"2C"%"22time"%"22"%"3A0.32804203033447265625"%"7D; PHPSESSID=80cd80213909dbd71631f7c5d8f5a0e7" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data "db_type=mysql&db_server=127.0.0.1&db_user=smf&db_passwd=smfpass&db_name=smf&db_filename="%"2Fvar"%"2Fwww"%"2Fsmf"%"2Fsmf_a692052ace&db_prefix=smf_&contbutt=Continue" > /dev/null \
	&& curl "http://localhost/install.php?step=3" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: en-CA,en;q=0.5" --compressed -H "Referer: http://localhost/install.php?step=2" -H "Content-Type: application/x-www-form-urlencoded" -H "Cookie: SMFCookie956=a"%"3A4"%"3A"%"7Bi"%"3A0"%"3Bi"%"3A1"%"3Bi"%"3A1"%"3Bs"%"3A40"%"3A"%"2259e4153dc9df79cf107d608cbafa8b6f334e14ec"%"22"%"3Bi"%"3A2"%"3Bi"%"3A1714614217"%"3Bi"%"3A3"%"3Bi"%"3A0"%"3B"%"7D; X-Handle-Time="%"7B"%"22start"%"22"%"3A1520274967.610455036163330078125"%"2C"%"22end"%"22"%"3A1520274967.938497066497802734375"%"2C"%"22time"%"22"%"3A0.32804203033447265625"%"7D; PHPSESSID=80cd80213909dbd71631f7c5d8f5a0e7" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data "mbname=My+Community&boardurl=http"%"3A"%"2F"%"2FSMF_BOARD_URL&compress=on&dbsession=on&utf8=on&contbutt=Continue" > /dev/null \
	&& curl "http://localhost/install.php?step=4" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: en-CA,en;q=0.5" --compressed -H "Referer: http://localhost/install.php?step=3" -H "Content-Type: application/x-www-form-urlencoded" -H "Cookie: SMFCookie956=a"%"3A4"%"3A"%"7Bi"%"3A0"%"3Bi"%"3A1"%"3Bi"%"3A1"%"3Bs"%"3A40"%"3A"%"2259e4153dc9df79cf107d608cbafa8b6f334e14ec"%"22"%"3Bi"%"3A2"%"3Bi"%"3A1714614217"%"3Bi"%"3A3"%"3Bi"%"3A0"%"3B"%"7D; X-Handle-Time="%"7B"%"22start"%"22"%"3A1520274967.610455036163330078125"%"2C"%"22end"%"22"%"3A1520274967.938497066497802734375"%"2C"%"22time"%"22"%"3A0.32804203033447265625"%"7D; PHPSESSID=80cd80213909dbd71631f7c5d8f5a0e7" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data "pop_done=1&contbutt=Continue" > /dev/null \
	&& curl "http://localhost/install.php?step=5" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Accept-Language: en-CA,en;q=0.5" --compressed -H "Referer: http://localhost/install.php?step=5" -H "Content-Type: application/x-www-form-urlencoded" -H "Cookie: SMFCookie956=a"%"3A4"%"3A"%"7Bi"%"3A0"%"3Bi"%"3A1"%"3Bi"%"3A1"%"3Bs"%"3A40"%"3A"%"2259e4153dc9df79cf107d608cbafa8b6f334e14ec"%"22"%"3Bi"%"3A2"%"3Bi"%"3A1714614217"%"3Bi"%"3A3"%"3Bi"%"3A0"%"3B"%"7D; X-Handle-Time="%"7B"%"22start"%"22"%"3A1520274967.610455036163330078125"%"2C"%"22end"%"22"%"3A1520274967.938497066497802734375"%"2C"%"22time"%"22"%"3A0.32804203033447265625"%"7D; PHPSESSID=80cd80213909dbd71631f7c5d8f5a0e7" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data "username=Admin&password1=admin&password2=admin&email=admin"%"40gmail.com&password3=smfpass&contbutt=Continue" > /dev/null \
	&& curl "http://localhost/install.php?delete=1&ts_1525403315647" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0" -H "Accept: */*" -H "Accept-Language: en-CA,en;q=0.5" --compressed -H "Referer: http://localhost/install.php?step=5" -H "Cookie: SMFCookie956=a"%"3A4"%"3A"%"7Bi"%"3A0"%"3Bi"%"3A1"%"3Bi"%"3A1"%"3Bs"%"3A40"%"3A"%"223136fd2ddd425cde6804e372d403dfce721c1527"%"22"%"3Bi"%"3A2"%"3Bi"%"3A1714619299"%"3Bi"%"3A3"%"3Bi"%"3A0"%"3B"%"7D; X-Handle-Time="%"7B"%"22start"%"22"%"3A1520274967.610455036163330078125"%"2C"%"22end"%"22"%"3A1520274967.938497066497802734375"%"2C"%"22time"%"22"%"3A0.32804203033447265625"%"7D; PHPSESSID=648388de8572abb23c0b91a9672209e4" -H "DNT: 1" -H "Connection: keep-alive" -H "Pragma: no-cache" -H "Cache-Control: no-cache" > /dev/null \
	&& service mysql stop \
	&& service apache2 stop
ADD repair_settings.php /
ADD start.sh /

EXPOSE 80
ENV SMF_BOARD_URL $SMF_BOARD_URL
CMD bash /start.sh
