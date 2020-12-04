FROM centos:7
MAINTAINER GE Scott Knauss scott@immauss.com

ADD ./start.sh /start.sh
ADD ./builder.sh /root/rpm-build/builder.sh
ADD ./remi-release-7.rpm /tmp/remi-release-7.rpm

RUN yum install -y epel-release; \
	yum install -y /tmp/remi-release-7.rpm; \
	yum update -y ; \
	yum -y install rpm-build rpmdevtools make cmake gcc  yum-utils  vim buildroot git \
	php74 php74-php php74-php-pear  \
	php74-php-phpiredis python3-devel python3-pip python36-lxml   python36-six \
	python36-setuptools wget php74-php-devel php74-build python36-dateutil php74-php-mbstring \
	bzip2-devel curl-devel gmp-devel httpd-devel pam-devel libstdc++-devel openssl-devel readline-devel krb5-devel \
	libc-client-devel cyrus-sasl-devel openldap-devel libxslt-devel libxml2-devel libjpeg-devel libpng-devel freetype-devel \
	libXpm-devel t1lib-devel sqlite-devel zlib-devel pcre-devel smtpdaemon libedit-devel libtool gcc-c++ libtool-ltdl-devel \
	tokyocabinet-devel libmcrypt-devel libtidy-devel aspell-devel recode-devel libicu-devel enchant-devel mysql-devel postgresql-devel \
	gd-devel libwebp-devel libicu-devel python3-httplib2 python36-PyYAML python36-attrs python36-backports_abc python36-beautifulsoup4 \
	python36-certifi python36-chardet python36-click python36-colorama python36-future python36-idna  python36-jsonschema \
	python36-nose python36-olefile python36-pillow python36-ply python36-pyparsing python36-pytz python36-requests \
	python36-simplejson python36-tornado python36-urllib3 python36-yara python36-zmq; \
	yum groups mark convert; \
    yum -y groupinstall 'Development Tools'; \
    ln -s /opt/remi/php74/root/usr/bin/php /usr/bin/php; \
    ln -s /opt/remi/php74/root/usr/bin/pear /usr/bin/pear; \
    mkdir /root/rpmbuild



WORKDIR /root/rpmbuild 
CMD /start.sh



