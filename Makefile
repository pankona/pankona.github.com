
all:
	GO111MODULE=on go get
	make -C $(CURDIR)/src

serve:
	make serve -C $(CURDIR)/src

deploy:
	make build -C $(CURDIR)/src
	cd $(CURDIR)/public; \
	git add . && git commit -m "Update site" && git push origin master

