# $Id: Makefile, v 1.6 2015/3/29 croadfeldt Exp $
#

PYTHON=`which python`
DESTDIR=/
BUILDIR=$(CURDIR)/debian/redeem
PROJECT=toggle
VERSION=0.5.0

all:
	@echo "make source - Create source package"
	@echo "make install - Install on local system"
	@echo "make buildrpm - Generate a rpm package"
	@echo "make builddeb - Generate a deb package"
	@echo "make clean - Get rid of scratch and byte files"

libtoggle-deb:
	$(MAKE) -f debian/rules configure
	$(MAKE) -f debian/rules build
	$(MAKE) -f debian/rules install

libtoggle:
	cd toggle-lib && ./autogen.sh --prefix=/usr --enable-introspection --libdir=/usr/lib/arm-linux-gnueabihf
	cd toggle-lib && make
	cd toggle-lib && make install

source:
	$(PYTHON) setup.py sdist $(COMPILE)

install:
	$(PYTHON) setup.py install --single-version-externally-managed --root $(DESTDIR) $(COMPILE) 

buildrpm:
	$(PYTHON) setup.py bdist_rpm --post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall

builddeb:
	# build the source package in the parent directory
	# then rename it to project_version.orig.tar.gz
	$(PYTHON) setup.py sdist $(COMPILE) --dist-dir=../
	rename -f 's/$(PROJECT)-(.*)\.tar\.gz/$(PROJECT)_$$1\.orig\.tar\.gz/' ../*
	# build the package
	dpkg-buildpackage -i -I -rfakeroot

clean:
	$(PYTHON) setup.py clean
	$(MAKE) -f $(CURDIR)/debian/rules clean
	rm -rf build/ MANIFEST
	find . -name '*.pyc' -delete
	make -C toggle-lib clean
	rm -rf toggle-lib/debian
	rm -rf toggle-lib/usr
	rm -rf usr
	rm -rf debian/python-toggle
