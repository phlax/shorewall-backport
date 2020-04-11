#!/usr/bin/make -f

SHELL := /bin/bash


debs:
	mkdir -p build
	chmod -R 777 build
	docker run -ti -v `pwd`/build:/home/bob phlax/debian-build bash -c "\
	  sudo apt-get -y -qq build-dep shorewall \
	  && sudo apt install -y -qq xz-utils \
	  && if [ ! -d shorewall-5.2.4 ]; then \
		wget https://shorewall.org/pub/shorewall/CURRENT_STABLE_VERSION_IS_5.2/shorewall-5.2.4/shorewall-5.2.4.tgz; \
	        tar zxf shorewall-5.2.4.tgz; \
		cd shorewall-5.2.4; \
		wget http://deb.debian.org/debian/pool/main/s/shorewall/shorewall_5.2.3.2-1.debian.tar.xz; \
		tar xf shorewall_5.2.3.2-1.debian.tar.xz; \
		ls; \
	 	export DEBFULLNAME=\"Bob the builder\"; \
		dch -v 5.2.4+bpo \"Adding backport!\"; \
		dpkg-buildpackage -us -uc -b; \
	     else \
		echo \"Source folder exists for shorewall-5.2.4\"; \
	     fi \
	  && cd \
	  && if [ ! -d shorewall-core-5.2.4 ]; then \
		wget https://shorewall.org/pub/shorewall/CURRENT_STABLE_VERSION_IS_5.2/shorewall-5.2.4/shorewall-core-5.2.4.tgz; \
	        tar zxf shorewall-core-5.2.4.tgz; \
		cd shorewall-core-5.2.4; \
		wget http://deb.debian.org/debian/pool/main/s/shorewall-core/shorewall-core_5.2.3.2-1.debian.tar.xz; \
		tar xf shorewall-core_5.2.3.2-1.debian.tar.xz; \
		ls; \
	 	export DEBFULLNAME=\"Bob the builder\"; \
		dch -v 5.2.4+bpo \"Adding backport!\"; \
		dpkg-buildpackage -us -uc -b; \
	     else \
		echo \"Source folder exists for shorewall-5.2.4\"; \
	     fi"

docker: debs
	docker run --name=shorewall -v `pwd`/build:/tmp/build debian:buster-slim bash -c "\
		ls /tmp/build -lh \
		&& mkdir -p /usr/share/shorewall-backport \
		&& cp -a /tmp/build/* /usr/share/shorewall-backport/ \
		&& apt update \
		&& apt install -y /tmp/build/shorewall-core_*deb \
		&& apt install -y /tmp/build/shorewall_*deb"
	docker commit shorewall phlax/shorewall-backport

hub-image:
	docker push phlax/shorewall-backport
