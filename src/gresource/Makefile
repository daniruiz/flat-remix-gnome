SCSS=sassc
BASE_THEME ?= ../../Flat-Remix
HIGH_CONTRAST_THEME ?= ../../Flat-Remix-Dark-fullPanel

.PHONY: build

build:
	cp $(BASE_THEME)/gnome-shell/gnome-shell.css .
	cp $(HIGH_CONTRAST_THEME)/gnome-shell/gnome-shell.css gnome-shell-high-contrast.css
	sed "s/assets/resource:\/\/\/org\/gnome\/shell\/theme/g" -i *.css
	glib-compile-resources gnome-shell-theme.gresource.xml
