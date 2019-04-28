# GNU make is required to run this file. To install on *BSD, run:
#   gmake PREFIX=/usr/local install

PREFIX ?= /usr
IGNORE ?=
THEMES ?= $(patsubst %/index.theme,%,$(wildcard ./*/index.theme))
MODES ?= flat-remix-darkest-fullpanel.json flat-remix-darkest.json flat-remix-dark-fullpanel.json flat-remix-dark.json flat-remix-fullpanel.json flat-remix.json flat-remix-miami-dark-fullpanel.json flat-remix-miami-dark.json flat-remix-miami-fullpanel.json flat-remix-miami.json
IS_UBUNTU ?= $(shell [ "$$(lsb_release -si 2> /dev/null)" = Ubuntu ] && echo true)


# excludes IGNORE from THEMES list
THEMES := $(filter-out $(IGNORE), $(THEMES))

all:
	cd src && HOME=$$(eval echo ~$$SUDO_USER) ./build.sh --sync-login-background

build:
	cd src && HOME=$$(eval echo ~$$SUDO_USER) ./build.sh -r

install:
	mkdir -p $(DESTDIR)$(PREFIX)/share/themes
	cp -a $(THEMES) $(DESTDIR)$(PREFIX)/share/themes/
	mkdir -p $(DESTDIR)$(PREFIX)/share/gnome-shell/theme
	$(foreach theme, $(THEMES), ln -sf $(PREFIX)/share/themes/$(theme)/gnome-shell $(DESTDIR)$(PREFIX)/share/gnome-shell/theme/$(theme);)
	mkdir -p $(DESTDIR)$(PREFIX)/share/gnome-shell/modes
	cp -a src/modes/* $(DESTDIR)$(PREFIX)/share/gnome-shell/modes/
	mkdir -p $(DESTDIR)$(PREFIX)/share/xsessions
	cp -a src/sessions/xsessions/* $(DESTDIR)$(PREFIX)/share/xsessions/
	mkdir -p $(DESTDIR)$(PREFIX)/share/wayland-sessions
	cp -a src/sessions/wayland-sessions/* $(DESTDIR)$(PREFIX)/share/wayland-sessions/
ifeq ($(IS_UBUNTU), true)
	ln -sf $(PREFIX)/share/themes/Flat-Remix/gnome-shell/assets/ $(DESTDIR)$(PREFIX)/share/gnome-shell/theme/assets
endif

	# skip replacing gnome's theme when packaging
	$(if $(DESTDIR),, $(MAKE) Flat-Remix)

$(THEMES):
ifeq ($(IS_UBUNTU), true)
	-ln -sf $(PREFIX)/share/themes/$@/gnome-shell/assets/ $(PREFIX)/share/gnome-shell/theme/assets
	-update-alternatives --install $(PREFIX)/share/gnome-shell/theme/gdm3.css gdm3.css $(PREFIX)/share/themes/$@/gnome-shell/gnome-shell.css 20
else
	-mv -n $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old
	-ln -sf $(PREFIX)/share/themes/$@/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource
endif

uninstall:
	-rm -rf $(foreach theme, $(THEMES), $(PREFIX)/share/themes/$(theme))
	-rm -rf $(foreach theme, $(THEMES) assets, $(PREFIX)/share/gnome-shell/theme/$(theme))
	-rm -rf $(foreach mode, $(MODES), $(PREFIX)/share/gnome-shell/modes/$(mode))
	-rm -rf $(PREFIX)/share/xsessions/??_flat-remix*.desktop
	-rm -rf $(PREFIX)/share/wayland-sessions/??_flat-remix*.desktop
ifeq ($(IS_UBUNTU), true)
	-$(foreach theme, $(THEMES), update-alternatives --remove gdm3.css /usr/share/themes/$(theme)/gnome-shell/gnome-shell.css 2> /dev/null;)
	-update-alternatives --auto gdm3.css
else
	-mv $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource
endif

_get_version:
	$(eval VERSION := $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

_get_tag:
	$(eval TAG := $(shell git describe --abbrev=0 --tags))
	@echo $(TAG)

dist: _get_version
	git archive --format=tar.gz -o $(notdir $(CURDIR))-$(VERSION).tar.gz master -- $(THEMES)

release: _get_version
	git tag -f $(VERSION)
	$(MAKE) aur_release
	$(MAKE) copr_release
	git push origin --tags

aur_release: _get_tag
	cd aur; \
	sed "s/pkgver\s*=.*/pkgver=$(TAG)/" -i PKGBUILD .SRCINFO; \
	makepkg --printsrcinfo > .SRCINFO; \
	git commit -a -m "$(TAG)"; \
	git push origin;

	git commit aur -m "$(TAG)"
	git push origin

copr_release: _get_tag
	sed "s/Version:.*/Version: $(TAG)/" -i flat-remix-gnome.spec
	git commit flat-remix-gnome.spec -m "Update flat-remix-gnome.spec version $(TAG)"
	git push origin

undo_release: _get_tag
	-git tag -d $(TAG)
	-git push --delete origin $(TAG)


.PHONY: $(THEMES) all install uninstall _get_version dist release undo_release

# .BEGIN is ignored by GNU make so we can use it as a guard
.BEGIN:
	@head -3 Makefile
	@false
