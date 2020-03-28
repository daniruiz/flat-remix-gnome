
PREFIX ?= /usr
THEMES ?= $(patsubst %/index.theme,%,$(wildcard */index.theme))
BASE_THEME ?= Flat-Remix
PKGNAME = flat-remix-gnomeMAINTAINER = Daniel Ruiz de Alegría <daniel@drasite.com>

install:
	mkdir -p $(PREFIX)/share/themes/
	cp -r $(THEMES) $(PREFIX)/share/themes/
	cp -r share/ $(PREFIX)/
	mkdir -p $(PREFIX)/share/gnome-shell/theme/
	ln -sfv $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/ $(PREFIX)/share/gnome-shell/theme/$(BASE_THEME)

uninstall:
	-rm -rf $(foreach theme, $(THEMES), $(PREFIX)/share/themes/$(theme))
	-rm -f $(foreach file, $(shell find share/ -type f), $(PREFIX)/$(file))
	-rm -f $(PREFIX)/share/gnome-shell/theme/$(BASE_THEME)

_get_version:
	$(eval VERSION ?= $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

_get_tag:
	$(eval TAG := $(shell git describe --abbrev=0 --tags))
	@echo $(TAG)

dist: _get_version
	color_variants="- -Dark"; \
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

generate_changelog: _get_version _get_tag
	git checkout $(TAG) CHANGELOG
	mv CHANGELOG CHANGELOG.old
	echo [$(VERSION)] > CHANGELOG
	git log --pretty=format:' * %s' $(TAG)..HEAD >> CHANGELOG
	echo | cat - CHANGELOG.old >> CHANGELOG
	rm CHANGELOG.old
	$$EDITOR CHANGELOG
	git commit CHANGELOG -m "Update CHANGELOG version $(VERSION)"
	git push origin HEAD

.PHONY: install _get_version _get_tag dist generate_changelog
