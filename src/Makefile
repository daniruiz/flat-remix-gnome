SUBDIRS=assets-renderer/gnome-shell sass
THEMES_DIR=../themes

include Makefile.inc

.PHONY: build $(SUBDIRS) clean

build: $(SUBDIRS)
	$(MAKE) -C gresource build
	# Remove variants that are not valid
	rm -rf $(foreach variant,$(UNWANTED_VARIANTS),$(THEMES_DIR)/Flat-Remix-$(variant)*)

$(SUBDIRS):
	$(MAKE) -C $@ build

clean:
	$(foreach SUBDIR,$(SUBDIRS),$(MAKE) -C $(SUBDIR) clean &&) true
