include ../Makefile.inc

THEMES_DIR=../../themes/

.PHONY: build clean

build: $(COLOR_VARIANTS) Miami

$(COLOR_VARIANTS):
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Light/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Light-fullPanel/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Dark/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Dark-fullPanel/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Darkest/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-$@-Darkest-fullPanel/gnome-shell
	sed -e '/$$selected_bg_color/c $$selected_bg_color: $(COLOR_$@);' \
	    -e '/$$selected_fg_color/c $$selected_fg_color: $(TEXT_COLOR_$@);' gnome-shell.scss | $(SCSS) > $(THEMES_DIR)/Flat-Remix-$@-Light/gnome-shell/gnome-shell.css
	sed -e '/$$selected_bg_color/c $$selected_bg_color: $(COLOR_$@);' \
	    -e '/$$selected_fg_color/c $$selected_fg_color: $(TEXT_COLOR_$@);' gnome-shell-fullpanel.scss | $(SCSS) > $(THEMES_DIR)/Flat-Remix-$@-Light-fullPanel/gnome-shell/gnome-shell.css
	sed -e '/$$selected_bg_color/c $$selected_bg_color: $(COLOR_$@);' \
	    -e '/$$selected_fg_color/c $$selected_fg_color: $(TEXT_COLOR_$@);' gnome-shell-dark.scss | $(SCSS) > $(THEMES_DIR)/Flat-Remix-$@-Dark/gnome-shell/gnome-shell.css
	sed -e '/$$selected_bg_color/c $$selected_bg_color: $(COLOR_$@);' \
	    -e '/$$selected_fg_color/c $$selected_fg_color: $(TEXT_COLOR_$@);' gnome-shell-dark-fullpanel.scss | $(SCSS) > $(THEMES_DIR)/Flat-Remix-$@-Dark-fullPanel/gnome-shell/gnome-shell.css
	sed -e '/$$selected_bg_color/c $$selected_bg_color: $(COLOR_$@);' \
	    -e '/$$selected_fg_color/c $$selected_fg_color: $(TEXT_COLOR_$@);' gnome-shell-darkest.scss | $(SCSS) > $(THEMES_DIR)/Flat-Remix-$@-Darkest/gnome-shell/gnome-shell.css
	sed -e '/$$selected_bg_color/c $$selected_bg_color: $(COLOR_$@);' \
	    -e '/$$selected_fg_color/c $$selected_fg_color: $(TEXT_COLOR_$@);' gnome-shell-darkest-fullpanel.scss | $(SCSS) > $(THEMES_DIR)/Flat-Remix-$@-Darkest-fullPanel/gnome-shell/gnome-shell.css

Miami:
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-fullPanel/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-Dark/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-Dark-fullPanel/gnome-shell
	$(SCSS) gnome-shell-miami.scss > $(THEMES_DIR)/Flat-Remix-Miami/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-miami-fullpanel.scss > $(THEMES_DIR)/Flat-Remix-Miami-fullPanel/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-miami-dark.scss > $(THEMES_DIR)/Flat-Remix-Miami-Dark/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-miami-dark-fullpanel.scss > $(THEMES_DIR)/Flat-Remix-Miami-Dark-fullPanel/gnome-shell/gnome-shell.css

clean:
