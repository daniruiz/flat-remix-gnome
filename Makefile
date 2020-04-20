PKGNAME = flat-remix-gnome
MAINTAINER = Daniel Ruiz de Alegría <daniel@drasite.com>
PREFIX ?= /usr
THEMES ?= $(patsubst %/index.theme,%,$(wildcard */index.theme))
BASE_THEME ?= Flat-Remix
BLUR ?= 6
IS_UBUNTU ?= $(shell [ "$$(lsb_release -si 2> /dev/null)" = Ubuntu ] && echo true)


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
	$(eval LOGIN_BACKGROUND ?= \
		$(shell printf "$$(\
			HOME=$$(eval echo ~$$SUDO_USER) \
			dconf read /org/gnome/desktop/background/picture-uri | \
			sed -e 's/file:\/\///' -e 's/%/\\x/g' -e s/\'//g)"))
	@echo "$(LOGIN_BACKGROUND)"

build:
	$(MAKE) -C src build

install:
ifeq ($(DESTDIR),)
	mkdir -p $(PREFIX)/share/themes/
	cp -r $(THEMES) $(PREFIX)/share/themes/
	cp -r share/ $(PREFIX)/
	mkdir -p $(PREFIX)/share/gnome-shell/theme/
	@ln -sfv $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/ $(PREFIX)/share/gnome-shell/theme/$(BASE_THEME)
    ifeq ($(IS_UBUNTU), true)
		cp src/gresource/gnome-shell-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource
		update-alternatives --install $(PREFIX)/share/gnome-shell/gdm3-theme.gresource gdm3-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource 100
    else
		mv -n $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old
		cp -f src/gresource/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource
    endif
else
	mkdir -p $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/
	cp -a Makefile $(THEMES) src share $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/
endif

uninstall:
	-rm -rf $(foreach theme, $(THEMES), $(PREFIX)/share/themes/$(theme))
	-rm -f $(foreach file, $(shell find share/ -type f), $(PREFIX)/$(file))
	-rm -f $(PREFIX)/share/gnome-shell/theme/$(BASE_THEME)
ifeq ($(IS_UBUNTU), true)
	-update-alternatives --remove gdm3-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource
	-update-alternatives --auto gdm3-theme.gresource
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
	color_variants="- -Dark -Darkest -Miami -Miami-Dark"; \
	theme_variants="- -fullPanel"; \
	count=1; \
	for color_variant in $$color_variants; \
	do \
		[ "$$color_variant" = '-' ] && color_variant=''; \
		for theme_variant in $$theme_variants; \
		do \
			[ "$$theme_variant" = '-' ] && theme_variant=''; \
			file="Flat-Remix$${color_variant}$${theme_variant}"; \
			if [ -d "$$file" ]; \
			then \
				count_pretty=$$(echo "0$${count}" | tail -c 3); \
				tar -c "$$file" | \
						xz -z - > "$${count_pretty}-$${file}_$(VERSION).tar.xz"; \
				count=$$((count+1)); \
			fi; \
		done; \
	done; \

release: _get_version
	$(MAKE) generate_changelog VERSION=$(VERSION)
	$(MAKE) aur_release VERSION=$(VERSION)
	$(MAKE) copr_release VERSION=$(VERSION)
	git tag -f $(VERSION)
	git push origin --tags
	$(MAKE) dist

aur_release: _get_version _get_tag
	cd aur; \
	sed "s/$(TAG)/$(VERSION)/g" -i PKGBUILD .SRCINFO; \
	git commit -a -m "$(VERSION)"; \
	git push origin master;

	git commit aur -m "Update aur version $(VERSION)"
	git push origin master

copr_release: _get_version _get_tag
	sed "s/$(TAG)/$(VERSION)/g" -i $(PKGNAME).spec
	git commit $(PKGNAME).spec -m "Update $(PKGNAME).spec version $(VERSION)"
	git push origin master

generate_changelog: _get_version _get_tag
	git checkout $(TAG) CHANGELOG
	mv CHANGELOG CHANGELOG.old
	echo [$(VERSION)] > CHANGELOG
	printf "%s\n\n" "$$(git log --pretty=format:' * %s' $(TAG)..HEAD)" >> CHANGELOG
	rm CHANGELOG.old
	$$EDITOR CHANGELOG
	git commit CHANGELOG -m "Update CHANGELOG version $(VERSION)"
	git push origin HEAD

clean:
	make -C src clean

.PHONY: all _get_login_background build install uninstall _get_version _get_tag dist release aur_release copr_release generate_changelog
