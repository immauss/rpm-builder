#!/bin/bash

# build  and install the two packages still needed to build misp
spectool -g -R SPECS/php-pear-Console_CommandLine.spec 
rpmbuild -bb SPECS/php-pear-Console_CommandLine.spec
yum install -y  RPMS/noarch/php-pear-Console_CommandLine-*rpm

spectool -g -R SPECS/php-pear-Crypt_GPG.spec
rpmbuild -bb SPECS/php-pear-Crypt_GPG.spec
yum install -y RPMS/noarch/php-pear-Crypt_GPG*rpm

rpmbuild -bb SPECS/misp.spec
