SCSS=sassc
BASE_THEME ?= ../../themes/Flat-Remix-Blue
HIGH_CONTRAST_THEME ?= ../../themes/Flat-Remix-Blue-Dark-fullPanel

.PHONY: build clean

build:
	-cp $(BASE_THEME)-Light/gnome-shell/gnome-shell.css gnome-shell.css
	-cp $(BASE_THEME)-Dark/gnome-shell/gnome-shell.css gnome-shell-dark.css
	-cp $(HIGH_CONTRAST_THEME)/gnome-shell/gnome-shell.css gnome-shell-high-contrast.css
	@ln -sfv gnome-shell-high-contrast.css gnome-shell-high-contrast-dark.css
	cp ../sass/gnome-shell/upstream/pad-osd.css .
	sed "s/assets/resource:\/\/\/org\/gnome\/shell\/theme/g" -i *.css
	glib-compile-resources gnome-shell-theme.gresource.xml

clean:
	rm *.css
