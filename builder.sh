#!/bin/bash
# Script to build MISP from the spec files at: 
# https://github.com/amuehlem/MISP-RPM
# This will be  the start.sh for a container with the build env 
# First build the spec files
# Working directory from Dockerfile should be /root/rpmbuild
git clone https://github.com/amuehlem/MISP-RPM.git
mv MISP-RPM/* .

# Download all the sources
for spec in $(ls SPECS/*.spec); do
	spectool -g -R SPECS/$spec
done

# Now start building.
# According to amuehlem, they need to be done in a specific order.
PrimaryTargets="php php-pear php-pear-CommandLine php-pear-Crypt_GPG php-redis python-cybox python-stix python-mixbox python-pydeep python-pymisp misp"
Modules="python36-pip python36-setuptools misp-stix-converter python36-libtaxii python36-lxml python36-six python36-python_dateutil python36-ordered_set python36-mixbox python36-cybox python36-stix python36-backports_abc python36-tornado python36-dnspython python36-chardet python36-nose python36-jsonschema python36-rdflib python36-beautifulsoup4 python36-colorlog python36-argparse python36-pytz python36-isodate python36-pyparsing python36-redis python36-pygeoip python36-idna python36-urllib3 python36-certifi python36-requests_cache python36-url_normalize python36-pillow python36-urlachriver python36-ez_setup python36-asnhistory python36-cabby python36-dateutils python36-furl python36-domaintools_api python36-ipasn_redis python36-orderedmultidict python36-passivetotal python36-olefile python36-pyaml python36-pypdns python36-pyeupi python36-pypssl python36-pytesseract python36-SPARQLWrapper python36-PyYAML python36-uwhois python36-shodan python36-XlsxWriter python36-colorama python36-click python36-click_plugins python36-future python36-requests python36-pymisp misp-modules"
for target in $PrmiaryTargets $Modules; do 
	# Check to see if RPM already exists before compiling.
	# Build the version
	package=$(awk /^Name:/'{ print $2 }'  ${target}.spec )
	version=$(awk /^Version:/'{print $2}' ${target}.spec)
	release=$(awk /^Release:/'{print $2}' ${target}.spec|sed -e "s/%.*$//")
	if [ -f RPMS/x86_64/${package}-${version}-${release}.el7.x86_64.rpm ]; then
		echo "Building $target"
		# Down load the source first using spectool
		echo "Downloading source for $target"
		spectool -g -R SPECS/${target}.spec
		# Make sure we have all the dependencies installed for the package
		echo "Installing build dependencies for $target."
		DEPENDS=$( rpmbuild -bp ${target}.spec 2>&1 | awk /needed/'{print $1} '| sort -u  | awk '{printf $0" "}' )
		#because the DEPENDS variable could have a space or two in it, we make sure it's long enough to have an actual package name.
		if  [ ${#DEPENDS} -gt 3 ]; then
			echo "$target needs the following dependencies:"
			echo "$DEPENDS"
			yum install -y $DEPENDS
		fi
		echo "Build $target with rpmbuild"
		rpmbuild -bb ${target}.spec
	else
		echo "Looks like RPMS/x86_64/${package}-${version}-${release}.el7.x86_64.rpm is already there."
		echo "Skipping build"
	fi
	
done

echo 'All done.'
ls -l /root/rpmbuild/RPMS/