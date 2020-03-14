_get_version:
	$(eval VERSION ?= $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

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
