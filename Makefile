
all:
	git submodule update
	make -C $(CURDIR)/src

serve:
	make serve -C $(CURDIR)/src
