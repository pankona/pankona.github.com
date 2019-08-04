
all:
ifdef post
	@make newpost
else
	@make build
endif

build:
	hugo
	rm -rf $(CURDIR)/../public/*
	mv public/* $(CURDIR)/../public/.

serve:
	hugo server -D --disableFastRender

newpost:
	hugo new posts/$(post).md

edit:
ifndef EDITOR
	EDITOR=vim
endif
	@cd $(CURDIR)/content/posts; $(EDITOR) `ls -t | peco`
