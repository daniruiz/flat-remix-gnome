SCSS=sassc
THEMES_DIR=../../

.PHONY: build clean

build:
	cp ../../Flat-Remix/gnome-shell/gnome-shell.css .
	cp ../../Flat-Remix-Dark-fullPanel/gnome-shell/gnome-shell.css gnome-shell-high-contrast.css
	sed "s/assets/resource:\/\/\/org\/gnome\/shell\/theme/g" -i *.css
	glib-compile-resources gnome-shell-theme.gresource.xml
	cp gnome-shell-theme.gresource ../../
