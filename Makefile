MAIN = main
NAME = ustcthesis
CLSFILES = $(NAME).cls
BSTFILES = $(NAME)-numerical.bst $(NAME)-authoryear.bst $(NAME)-bachelor.bst

# official docker image is https://hub.docker.com/r/texlive/texlive but only for amd64
# use https://hub.docker.com/r/zydou/texlive for both amd64 and arm64
DOCKER_IMAGE = zydou/texlive:latest
DOCKER_BASE_CMD = docker run --rm -it -v $(shell pwd):/workdir -w /workdir $(DOCKER_IMAGE)
SHELL = bash
LATEXMK = latexmk -xelatex
VERSION = $(shell cat $(NAME).cls | egrep -o "\\ustcthesisversion{v[0-9.]+" \
	  | egrep -o "v[0-9.]+")
TEXMF = $(shell kpsewhich --var-value TEXMFHOME)

.PHONY : main cls doc test save clean all install distclean zip FORCE_MAKE

docker-main :
	$(DOCKER_BASE_CMD) make main

docker-doc :
	$(DOCKER_BASE_CMD) make doc

docker-clean :
	$(DOCKER_BASE_CMD) make clean

docker-cleanall :
	$(DOCKER_BASE_CMD) make cleanall

main : $(MAIN).pdf

all : main doc

cls : $(CLSFILES) $(BSTFILES)

doc : $(NAME)-doc.pdf

$(MAIN).pdf : $(MAIN).tex $(CLSFILES) $(BSTFILES) FORCE_MAKE
	$(LATEXMK) $<

$(NAME)-doc.pdf : $(NAME)-doc.tex FORCE_MAKE
	$(LATEXMK) $<

test:
	l3build check

save:
	bash test/save.sh

clean : FORCE_MAKE
	$(LATEXMK) -c $(MAIN).tex $(NAME)-doc.tex

cleanall :
	$(LATEXMK) -C $(MAIN).tex $(NAME)-doc.tex

install : cls doc
	mkdir -p $(TEXMF)/{doc,source,tex}/latex/$(NAME)
	mkdir -p $(TEXMF)/bibtex/bst/$(NAME)
	cp $(BSTFILES) $(TEXMF)/bibtex/bst/$(NAME)
	cp $(NAME).pdf $(TEXMF)/doc/latex/$(NAME)
	cp $(CLSFILES) $(TEXMF)/tex/latex/$(NAME)

zip : main doc
	ln -sf . $(NAME)
	zip -r ../$(NAME)-$(VERSION).zip $(NAME)/{*.md,LICENSE,\
	$(NAME)-doc.tex,$(NAME)-doc.pdf,$(NAME).cls,*.bst,*.bbx,*.cbx,figures,\
	$(MAIN).tex,ustcsetup.tex,chapters,bib,$(MAIN).pdf,\
	latexmkrc,Makefile}
	rm $(NAME)
