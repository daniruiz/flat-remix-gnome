include ../../Makefile.inc

THEMES_DIR=../../../themes/

.PHONY: build clean

build: $(COLOR_VARIANTS) Miami

$(COLOR_VARIANTS):
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Light/gnome-shell/assets
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Light-fullPanel/gnome-shell/assets
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Dark/gnome-shell/assets
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Dark-fullPanel/gnome-shell/assets
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Darkest/gnome-shell/assets
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Darkest-fullPanel/gnome-shell/assets
	cp assets/* $(THEMES_DIR)Flat-Remix-$@-Light/gnome-shell/assets/
	sed 's/$(DEFAULT_THEME_COLOR)/$(COLOR_$@)/gi' -i $(THEMES_DIR)Flat-Remix-$@-Light/gnome-shell/assets/*
	cp $(THEMES_DIR)Flat-Remix-$@-Light/gnome-shell/assets/* $(THEMES_DIR)Flat-Remix-$@-Light-fullPanel/gnome-shell/assets/
	cp $(THEMES_DIR)Flat-Remix-$@-Light/gnome-shell/assets/* $(THEMES_DIR)Flat-Remix-$@-Dark/gnome-shell/assets/
	cp $(THEMES_DIR)Flat-Remix-$@-Light/gnome-shell/assets/* $(THEMES_DIR)Flat-Remix-$@-Dark-fullPanel/gnome-shell/assets/
	cp $(THEMES_DIR)Flat-Remix-$@-Light/gnome-shell/assets/* $(THEMES_DIR)Flat-Remix-$@-Darkest/gnome-shell/assets/
	cp $(THEMES_DIR)Flat-Remix-$@-Light/gnome-shell/assets/* $(THEMES_DIR)Flat-Remix-$@-Darkest-fullPanel/gnome-shell/assets/

Miami:
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami/gnome-shell/assets
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-fullPanel/gnome-shell/assets
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-Dark/gnome-shell/assets
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-Dark-fullPanel/gnome-shell/assets
	cp assets/* $(THEMES_DIR)/Flat-Remix-Miami/gnome-shell/assets/
	cp assets/* $(THEMES_DIR)/Flat-Remix-Miami-fullPanel/gnome-shell/assets/
	cp assets/* $(THEMES_DIR)/Flat-Remix-Miami-Dark/gnome-shell/assets/
	cp assets/* $(THEMES_DIR)/Flat-Remix-Miami-Dark-fullPanel/gnome-shell/assets/

clean:
