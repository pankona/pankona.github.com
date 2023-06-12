
all:
ifdef post
	@make newpost
else
	@make build
endif

build:
	hugo

serve:
	hugo server -D --disableFastRender

newpost:
	hugo new posts/$(post).md

edit:
ifndef EDITOR
	EDITOR=vim
endif
	@cd $(CURDIR)/content/posts; $(EDITOR) `ls -t | peco`
