FROM centos:7
MAINTAINER GE Scott Knauss scott@immauss.com

# Install a grunch of dependencies for the build. Most of these are just for php
RUN yum -y install rpm-build rpmdevtools make cmake gcc  yum-utils  vim buildroot epel-release git \
	bzip2-devel curl-devel gmp-devel httpd-devel pam-devel libstdc++-devel openssl-devel readline-devel krb5-devel \
	libc-client-devel cyrus-sasl-devel openldap-devel libxslt-devel libxml2-devel libjpeg-devel libpng-devel freetype-devel \
	libXpm-devel t1lib-devel sqlite-devel zlib-devel pcre-devel smtpdaemon libedit-devel libtool gcc-c++ libtool-ltdl-devel \
	tokyocabinet-devel libmcrypt-devel libtidy-devel aspell-devel recode-devel libicu-devel enchant-devel mysql-devel postgresql-devel \
	gd-devel libwebp-devel libicu-devel \
    yum -y groupinstall 'Developement Tools' \
    mkdir /root/rpmbuild

ADD ./start.sh /start.sh
ADD ./builder.sh /root/rpm-build/builder.sh

WORKDIR /root/rpmbuild 
CMD /start.sh


