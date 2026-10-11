PKG_NAME := anbernic-rg353x-headphone-detect
PKG_VER  := 1.0.0
PKG_ARCH := all
DEB_FILE := build/$(PKG_NAME)_$(PKG_VER)_$(PKG_ARCH).deb

.PHONY: all deb clean

all: deb

deb: $(DEB_FILE)

$(DEB_FILE): bin/headphone-jack-detect systemd/headphone-jack-detect.service debian/control wireplumber/50-anbernic-rg353x.conf
	@rm -rf build/staging
	@umask 022 && mkdir -p build/staging/DEBIAN \
		build/staging/usr/bin \
		build/staging/usr/lib/systemd/system \
		build/staging/usr/share/wireplumber/wireplumber.conf.d
	@cp -r debian/* build/staging/DEBIAN/
	@chmod 644 build/staging/DEBIAN/control
	@chmod 755 build/staging/DEBIAN/postinst build/staging/DEBIAN/prerm build/staging/DEBIAN/postrm
	@install -m 755 bin/headphone-jack-detect build/staging/usr/bin/headphone-jack-detect
	@install -m 644 systemd/headphone-jack-detect.service build/staging/usr/lib/systemd/system/headphone-jack-detect.service
	@install -m 644 wireplumber/50-anbernic-rg353x.conf build/staging/usr/share/wireplumber/wireplumber.conf.d/50-anbernic-rg353x.conf
	@dpkg-deb --build --root-owner-group build/staging $(DEB_FILE)
	@rm -rf build/staging
	@echo "[build] Successfully created $(DEB_FILE)"

clean:
	rm -rf build
