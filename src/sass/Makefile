include ../Makefile.inc

THEMES_DIR=../../themes/

.PHONY: build clean

build:
	mkdir -p $(THEMES_DIR)/Flat-Remix-Light/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Light-fullPanel/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Dark/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Dark-fullPanel/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Darkest/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Darkest-fullPanel/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-fullPanel/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-Dark/gnome-shell
	mkdir -p $(THEMES_DIR)/Flat-Remix-Miami-Dark-fullPanel/gnome-shell
	$(SCSS) gnome-shell.scss > $(THEMES_DIR)/Flat-Remix-Light/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-fullpanel.scss > $(THEMES_DIR)/Flat-Remix-Light-fullPanel/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-dark.scss > $(THEMES_DIR)/Flat-Remix-Dark/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-dark-fullpanel.scss > $(THEMES_DIR)/Flat-Remix-Dark-fullPanel/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-darkest.scss > $(THEMES_DIR)/Flat-Remix-Darkest/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-darkest-fullpanel.scss > $(THEMES_DIR)/Flat-Remix-Darkest-fullPanel/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-miami.scss > $(THEMES_DIR)/Flat-Remix-Miami/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-miami-fullpanel.scss > $(THEMES_DIR)/Flat-Remix-Miami-fullPanel/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-miami-dark.scss > $(THEMES_DIR)/Flat-Remix-Miami-Dark/gnome-shell/gnome-shell.css
	$(SCSS) gnome-shell-miami-dark-fullpanel.scss > $(THEMES_DIR)/Flat-Remix-Miami-Dark-fullPanel/gnome-shell/gnome-shell.css

clean:
