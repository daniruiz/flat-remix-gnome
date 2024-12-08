include ../Makefile.inc

THEMES_DIR=../../themes/

THEMES=Flat-Remix-Light Flat-Remix-Dark Flat-Remix-Darkest Flat-Remix-Miami Flat-Remix-Miami-Dark
THEMES:=$(THEMES) $(foreach THEME, $(THEMES), $(THEME)-fullPanel)

.PHONY: build clean

build: $(THEMES)

$(THEMES):
	mkdir -p $(THEMES_DIR)/$@/gnome-shell/assets
	cp assets/* $(THEMES_DIR)/$@/gnome-shell/assets

clean:
