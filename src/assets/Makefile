THEMES_ASSETS_DIR ?= $(patsubst %/index.theme,%/gnome-shell/assets/,$(wildcard ../../*/index.theme))

.PHONY: build

build:
	rm -rf $(THEMES_ASSETS_DIR)
	mkdir -p $(THEMES_ASSETS_DIR)
	$(foreach theme_assets_dir, $(THEMES_ASSETS_DIR), cp *.svg $(theme_assets_dir) &&) true
