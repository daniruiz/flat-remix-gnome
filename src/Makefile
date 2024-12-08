SUBDIRS=assets-renderer sass
THEMES_DIR=../themes

include Makefile.inc

.PHONY: build $(SUBDIRS) clean

build: $(SUBDIRS)
	$(MAKE) -C gresource build

$(SUBDIRS):
	$(MAKE) -C $@ build

clean:
	$(foreach SUBDIR,$(SUBDIRS),$(MAKE) -C $(SUBDIR) clean &&) true
