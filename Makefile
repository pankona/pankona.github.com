all:
ifdef post
	hugo --panicOnWarning new posts/$(post).md
else
	hugo --panicOnWarning
endif

serve:
	hugo --panicOnWarning server -D --disableFastRender

edit:
ifndef EDITOR
	EDITOR=vim
endif
	@cd $(CURDIR)/content/posts; $(EDITOR) `ls -t | peco`

deps:
	nix --version
	hugo version
	go version
	make --version
	dprint --version
	typos --version
	convert --version
	actionlint --version
	ls --version
	nixfmt --version
	nixd --version
	peco --version
	vim --version | sed -n '1p'
	markdownlint-cli2 --version | grep 'markdownlint v'
