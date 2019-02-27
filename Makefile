# GNU make is required to run this file. To install on *BSD, run:
#   gmake PREFIX=/usr/local install

PREFIX ?= /usr
IGNORE ?=
THEMES ?= Flat-Remix Flat-Remix-Dark Flat-Remix-Darkest Flat-Remix-Darkest-fullPanel Flat-Remix-Dark-fullPanel Flat-Remix-fullPanel Flat-Remix-Miami Flat-Remix-Miami-Dark Flat-Remix-Miami-Dark-fullPanel Flat-Remix-Miami-fullPanel
MODES ?= flat-remix-darkest-fullpanel.json flat-remix-darkest.json flat-remix-dark-fullpanel.json flat-remix-dark.json flat-remix-fullpanel.json flat-remix.json flat-remix-miami-dark-fullpanel.json flat-remix-miami-dark.json flat-remix-miami-fullpanel.json flat-remix-miami.json


# excludes IGNORE from THEMES list
THEMES := $(filter-out $(IGNORE), $(THEMES))

all:

install:
	install -dm755 "$(DESTDIR)$(PREFIX)/share/themes"
	cp -a $(THEMES) "$(DESTDIR)$(PREFIX)/share/themes"
	install -dm755 "$(DESTDIR)$(PREFIX)/share/gnome-shell/theme"
	for theme in $(THEMES); \
	do \
		ln -sf "$(PREFIX)/share/themes/$${theme}/gnome-shell" "$(DESTDIR)$(PREFIX)/share/gnome-shell/theme/$${theme}"; \
	done
	install -dm755 "$(DESTDIR)$(PREFIX)/share/gnome-shell/modes"
	cp -a src/modes/* "$(DESTDIR)$(PREFIX)/share/gnome-shell/modes/"
	install -dm755 "$(DESTDIR)$(PREFIX)/share/xsessions"
	cp -a src/sessions/xsessions/* "$(DESTDIR)$(PREFIX)/share/xsessions/"
	install -dm755 "$(DESTDIR)$(PREFIX)/share/wayland-sessions"
	cp -a src/sessions/wayland-sessions/* "$(DESTDIR)$(PREFIX)/share/wayland-sessions/"
uninstall:
	-rm -rf $(foreach theme, $(THEMES), $(DESTDIR)$(PREFIX)/share/themes/$(theme))
	-rm -rf $(foreach theme, $(THEMES), $(DESTDIR)$(PREFIX)/share/gnome-shell/theme/$(theme))
	-rm -rf $(foreach mode, $(MODES), $(DESTDIR)$(PREFIX)/share/gnome-shell/modes/$(mode).json)
	-rm -rf $(DESTDIR)$(PREFIX)/share/xsessions/?_flat-remix*.desktop
	-rm -rf $(DESTDIR)$(PREFIX)/share/wayland-sessions/?_flat-remix*.desktop

_get_version:
	$(eval VERSION := $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

dist: _get_version
	git archive --format=tar.gz -o $(notdir $(CURDIR))-$(VERSION).tar.gz master -- $(THEMES)

release: _get_version
	git tag -f $(VERSION)
	git push origin
	git push origin --tags

undo_release: _get_version
	-git tag -d $(VERSION)
	-git push --delete origin $(VERSION)


.PHONY: $(THEMES) all install uninstall _get_version dist release undo_release

# .BEGIN is ignored by GNU make so we can use it as a guard
.BEGIN:
	@head -3 Makefile
	@false
