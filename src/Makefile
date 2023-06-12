
all:
ifdef post
	@make newpost
else
	@make build
endif

build:
	hugo --panicOnWarning

serve:
	hugo --panicOnWarning server -D --disableFastRender

newpost:
	hugo --panicOnWarning new posts/$(post).md

edit:
ifndef EDITOR
	EDITOR=vim
endif
	@cd $(CURDIR)/content/posts; $(EDITOR) `ls -t | peco`
