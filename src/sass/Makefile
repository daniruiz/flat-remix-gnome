SCSS=sassc
THEMES_DIR=../../

.PHONY: build clean

build:
	for scss in *.scss ; \
	do \
		echo ; \
		echo Generating $${scss%.scss}.css ; \
		$(SCSS) $$scss > $${scss%.scss}.css ; \
	done
	
	mkdir -p $(THEMES_DIR)Flat-Remix/gnome-shell
	mkdir -p $(THEMES_DIR)Flat-Remix-Dark/gnome-shell
	
	cp gnome-shell-light.css $(THEMES_DIR)Flat-Remix/gnome-shell/gnome-shell.css
	cp gnome-shell-dark.css $(THEMES_DIR)Flat-Remix-Dark/gnome-shell/gnome-shell.css

clean:
	-rm *.css
