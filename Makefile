# GNU make is required to run this file. To install on *BSD, run:
#   gmake PREFIX=/usr/local install

PREFIX ?= /usr
IGNORE ?=
THEMES ?= $(patsubst %/index.theme,%,$(wildcard ./*/index.theme))
MODES ?= flat-remix-darkest-fullpanel.json flat-remix-darkest.json flat-remix-dark-fullpanel.json flat-remix-dark.json flat-remix-fullpanel.json flat-remix.json flat-remix-miami-dark-fullpanel.json flat-remix-miami-dark.json flat-remix-miami-fullpanel.json flat-remix-miami.json


# excludes IGNORE from THEMES list
THEMES := $(filter-out $(IGNORE), $(THEMES))

all:

install:
	mkdir -p $(DESTDIR)$(PREFIX)/share/themes
	cp -a $(THEMES) $(DESTDIR)$(PREFIX)/share/themes/
	mkdir -p $(DESTDIR)$(PREFIX)/share/gnome-shell/theme
	for theme in $(THEMES); \
	do \
		ln -sf $(PREFIX)/share/themes/$${theme}/gnome-shell $(DESTDIR)$(PREFIX)/share/gnome-shell/theme/$${theme}; \
	done
	mkdir -p $(DESTDIR)$(PREFIX)/share/gnome-shell/modes
	cp -a src/modes/* $(DESTDIR)$(PREFIX)/share/gnome-shell/modes/
	mkdir -p $(DESTDIR)$(PREFIX)/share/xsessions
	cp -a src/sessions/xsessions/* $(DESTDIR)$(PREFIX)/share/xsessions/
	mkdir -p $(DESTDIR)$(PREFIX)/share/wayland-sessions
	cp -a src/sessions/wayland-sessions/* $(DESTDIR)$(PREFIX)/share/wayland-sessions/

	# skip replacing gnome's gresource file when packaging
	$(if $(DESTDIR),,$(MAKE) Flat-Remix)

$(THEMES):
	-mv -n $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old
	-ln -sf $(PREFIX)/share/themes/$@/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource

uninstall:
	-rm -rf $(foreach theme, $(THEMES), $(PREFIX)/share/themes/$(theme))
	-rm -rf $(foreach theme, $(THEMES), $(PREFIX)/share/gnome-shell/theme/$(theme))
	-rm -rf $(foreach mode, $(MODES), $(PREFIX)/share/gnome-shell/modes/$(mode))
	-rm -rf $(PREFIX)/share/xsessions/??_flat-remix*.desktop
	-rm -rf $(PREFIX)/share/wayland-sessions/??_flat-remix*.desktop
	-mv $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource

_get_version:
	$(eval VERSION := $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

dist: _get_version
	git archive --format=tar.gz -o $(notdir $(CURDIR))-$(VERSION).tar.gz master -- $(THEMES)

aur_release: _get_version
	cd aur; \
	sed "s/pkgver=.*/pkgver=$(VERSION)/" -i PKGBUILD; \
	makepkg --printsrcinfo > .SRCINFO; \
	git commit -a -m "$(VERSION)"; \
	git push origin

copr_release: _get_version
	sed "s/Version:.*/Version: $(VERSION)/" -i flat-remix-gnome.spec

release: _get_version
	$(MAKE) aur_release
	$(MAKE) copr_release
	git tag -f $(VERSION)
	git push origin --tags

undo_release: _get_version
	-git tag -d $(VERSION)
	-git push --delete origin $(VERSION)


.PHONY: $(THEMES) all install uninstall _get_version dist release undo_release

# .BEGIN is ignored by GNU make so we can use it as a guard
.BEGIN:
	@head -3 Makefile
	@false
