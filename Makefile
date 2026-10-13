PKG_NAME := anbernic-rg353x-audio-utils
PKG_VER  := 1.1.1
PKG_ARCH := all
DEB_FILE := build/$(PKG_NAME)_$(PKG_VER)_$(PKG_ARCH).deb

.PHONY: all deb install clean

all:

deb: $(DEB_FILE)

$(DEB_FILE): bin/headphone-jack-detect systemd/headphone-jack-detect.service debian/control debian/changelog debian/rules wireplumber/50-anbernic-rg353x.conf pipewire/50-anbernic-rg353x.conf
	dpkg-buildpackage -us -uc -b
	@mkdir -p build
	@cp ../$(PKG_NAME)_$(PKG_VER)*_$(PKG_ARCH).deb build/ 2>/dev/null || cp ../$(PKG_NAME)_$(PKG_VER)*.deb build/
	@echo "[build] Successfully created $(DEB_FILE)"

install:
	install -d $(DESTDIR)/usr/bin
	install -m 755 bin/headphone-jack-detect $(DESTDIR)/usr/bin/headphone-jack-detect
	install -d $(DESTDIR)/usr/lib/systemd/system
	install -m 644 systemd/headphone-jack-detect.service $(DESTDIR)/usr/lib/systemd/system/headphone-jack-detect.service
	install -d $(DESTDIR)/usr/share/wireplumber/wireplumber.conf.d
	install -m 644 wireplumber/50-anbernic-rg353x.conf $(DESTDIR)/usr/share/wireplumber/wireplumber.conf.d/50-anbernic-rg353x.conf
	install -d $(DESTDIR)/usr/share/pipewire/pipewire.conf.d
	install -m 644 pipewire/50-anbernic-rg353x.conf $(DESTDIR)/usr/share/pipewire/pipewire.conf.d/50-anbernic-rg353x.conf

clean:
	dh_clean 2>/dev/null || true
	rm -rf build debian/.debhelper debian/debhelper-build-stamp debian/anbernic-rg353x-audio-utils debian/files debian/*.substvars debian/*.debhelper debian/*.debhelper.log
	rm -f ../$(PKG_NAME)_$(PKG_VER)*.deb ../$(PKG_NAME)_$(PKG_VER)*.buildinfo ../$(PKG_NAME)_$(PKG_VER)*.changes
