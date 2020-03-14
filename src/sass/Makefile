SCSS=sassc
THEMES_DIR=../../

.PHONY: build clean

build:
	for scss in *.scss ; \
	do \
		echo ; \
		dir=$(THEMES_DIR)$${scss%.scss} ; \
		css_file=$${scss%.scss}.css ; \
		echo Generating $$css_file ; \
		$(SCSS) $$scss > $$css_file ; \
		if [ -d $$dir ] ; \
		then \
			mkdir -p $$dir/gnome-shell ; \
			cp $$css_file $$dir/gnome-shell/gnome-shell.css ; \
		fi ; \
	done

clean:
	-rm *.css
