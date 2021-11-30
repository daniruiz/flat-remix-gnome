PKGNAME = flat-remix-gnome
MAINTAINER = Daniel Ruiz de Alegría <daniel@drasite.com>
UBUNTU_RELEASE = impish
PREFIX ?= /usr
THEMES ?= $(patsubst themes/%/,%,$(wildcard themes/*/))
BASE_THEME ?= Flat-Remix-Blue-Light
BLUR ?= 6
IS_UBUNTU ?= $(shell echo "$$(lsb_release -si 2> /dev/null)" | grep -q 'Ubuntu\|Pop' && echo true)
USER_HOME ?= $(shell eval echo ~$$SUDO_USER)

include src/Makefile.inc

# !! Patch for pamac
# Pamac installs packages as root, no 'sudo' (due to pkexec), so dconf is unable
# to get the user's background. As a workaround HOME env is set to the home
# directory of the user with uid 1000, which probably will be the main user.
ifeq ($(USER_HOME),/root)
	USER_HOME = $(shell eval echo ~$(shell cut -d: -f1,3 /etc/passwd | grep -Po '.*(?=:1000)'))
endif


all: _get_login_background
	-if [ ! -z "$(LOGIN_BACKGROUND)" ] && [ "$(suffix $(LOGIN_BACKGROUND))" != ".xml" ] ; \
	then \
		if [ $(BLUR) -le 1 ] ;\
		then \
			cp -f "$(LOGIN_BACKGROUND)" src/gresource/login-background ;\
		else \
			convert -scale 10% -gaussian-blur 0x$(BLUR) -resize 1000% "$(LOGIN_BACKGROUND)" src/gresource/login-background ;\
		fi; \
	fi
	make -C src/gresource build

_get_login_background:
	$(eval SHELL:=/bin/bash)
	$(eval LOGIN_BACKGROUND ?= \
		$(shell printf "%b" "$$(\
			HOME=$(USER_HOME) dconf read /org/gnome/desktop/background/picture-uri | \
			sed -e 's/file:\/\///' -e 's/%/\\x/g' -e s/\'//g)"))
	@echo "$(LOGIN_BACKGROUND)"

build:
	$(MAKE) -C src build

install:
ifeq ($(DESTDIR),)
	mkdir -p $(PREFIX)/share/themes/
	cp -a $(foreach theme,$(THEMES),themes/$(theme)) $(DESTDIR)$(PREFIX)/share/themes
	cp -r share/ $(PREFIX)/
	glib-compile-schemas $(PREFIX)/share/glib-2.0/schemas/
	mkdir -p $(PREFIX)/share/gnome-shell/theme/
	@ln -sfv $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/ $(PREFIX)/share/gnome-shell/theme/$(BASE_THEME)
    ifeq ($(IS_UBUNTU), true)
		cp src/gresource/gnome-shell-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource
		update-alternatives --install $(PREFIX)/share/gnome-shell/gdm-theme.gresource gdm-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource 100
    else
		mv -n $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old
		cp -f src/gresource/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource
    endif
else
	mkdir -p $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/
	cp -a Makefile themes src share $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/
endif

uninstall:
	-rm -rf $(foreach theme, $(THEMES), $(PREFIX)/share/themes/$(theme))
	-rm -f $(foreach file, $(shell find share/ -type f), $(PREFIX)/$(file))
	-rm -f $(PREFIX)/share/gnome-shell/theme/$(BASE_THEME)
ifeq ($(IS_UBUNTU), true)
	-update-alternatives --remove gdm-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource
else
	-mv $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource
endif

_get_version:
	$(eval VERSION ?= $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

_get_tag:
	$(eval TAG := $(shell git describe --abbrev=0 --tags))
	@echo $(TAG)

dist: _get_version
	count=1; \
	for color_variant in $(COLOR_VARIANTS) Miami; \
	do \
		count_pretty=$$(echo "0$${count}" | tail -c 3); \
		(cd themes && tar -c "Flat-Remix-$${color_variant}"*) | \
			xz -z - > "$${count_pretty}-Flat-Remix-$${color_variant}_$(VERSION).tar.xz"; \
		count=$$((count+1)); \
	done; \

release: _get_version
	$(MAKE) generate_changelog VERSION=$(VERSION)
	$(MAKE) aur_release VERSION=$(VERSION)
	$(MAKE) copr_release VERSION=$(VERSION)
	#$(MAKE) launchpad_release VERSION=$(VERSION)
	git tag -f $(VERSION)
	git push origin --tags
	$(MAKE) dist

aur_release: _get_version
	cd aur; \
	sed "s/pkgver=.*/pkgver=$(VERSION)/" -i PKGBUILD; \
	sed "s/pkgver =.*/pkgver = $(VERSION)/" -i .SRCINFO; \
	git commit -a -m "$(VERSION)"; \
	git push origin master;

	git commit aur -m "Update aur version $(VERSION)"
	git push origin master

copr_release: _get_version
	sed "/Version:/c Version: $(VERSION)" -i $(PKGNAME).spec
	git commit $(PKGNAME).spec -m "Update $(PKGNAME).spec version $(VERSION)"
	git push origin master

launchpad_release: _get_version
	rm -rf /tmp/$(PKGNAME)
	mkdir -p /tmp/$(PKGNAME)/$(PKGNAME)_$(VERSION)
	cp -a * /tmp/$(PKGNAME)/$(PKGNAME)_$(VERSION)
	cd /tmp/$(PKGNAME)/$(PKGNAME)_$(VERSION); \
	echo "$(PKGNAME) ($(VERSION)) $(UBUNTU_RELEASE); urgency=low" > debian/changelog; \
	echo >> debian/changelog; \
	echo "  * Release $(VERSION)" >> debian/changelog; \
	echo >> debian/changelog; \
	echo " -- $(MAINTAINER)  $$(date -R)" >> debian/changelog; \
	debuild -S -d; \
	dput ppa:daniruiz/flat-remix /tmp/$(PKGNAME)/$(PKGNAME)_$(VERSION)_source.changes

generate_changelog: _get_version _get_tag
	git checkout $(TAG) CHANGELOG
	mv CHANGELOG CHANGELOG.old
	echo [$(VERSION)] > CHANGELOG
	printf "%s\n\n" "$$(git log --pretty=format:' * %s' $(TAG)..HEAD)" >> CHANGELOG
	cat CHANGELOG.old >> CHANGELOG
	rm CHANGELOG.old
	$$EDITOR CHANGELOG
	git commit CHANGELOG -m "Update CHANGELOG version $(VERSION)"
	git push origin HEAD

clean:
	-make -C src clean

.PHONY: all _get_login_background build install uninstall _get_version _get_tag dist release aur_release copr_release launchpad_release generate_changelog
