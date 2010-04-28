################################################################
################################################################
# Makefile for "biblatex-nature"                               #
################################################################
################################################################

################################################################
# Default with no target is to give help                       #
################################################################

help:
	@echo ""
	@echo " make clean        - remove generated files"
	@echo " make ctan         - create archive for CTAN"
	@echo " make doc          - create documentation"  
	@echo " make localinstall - install files in local texmf tree"
	@echo " make tds          - make TDS-ready archive"
	@echo ""

##############################################################
# Master package name                                        #
##############################################################

PACKAGE = biblatex-nature

##############################################################
# Directory structure for making zip files                   #
##############################################################

CTANROOT := ctan
CTANDIR  := $(CTANROOT)/$(PACKAGE)
TDSDIR   := tds

##############################################################
# Data for local installation and TDS construction           #
##############################################################

INCLUDEPDF  := $(PACKAGE)
INCLUDETEX  :=
INCLUDETXT  := README
PACKAGEROOT := latex/$(PACKAGE)

##############################################################
# Clean-up information                                       #
##############################################################

AUXFILES = \
	aux  \
	bbl  \
	blg \
	cmds \
	glo  \
	gls  \
	hd   \
	idx  \
	ilg  \
	ind  \
	log  \
	out  \
	tmp  \
	toc  
		
CLEAN = \
	gz  \
	ins \
	pdf \
	sty \
	txt \
	zip 

DOCS     = 
STYLES   = nature
TDS      = latex/$(PACKAGE)

# Even if files exist, use the rules here

.PHONY: clean ctan doc localinstall help tds

# The business end

clean:
	for I in $(AUXFILES) $(CLEAN) ; do \
      rm -rf *.$$I ; \
	done
	for I in $(STYLES) ; do \
	  rm -rf style-$$I-blx.bib ; \
	done 

ctan: tds
	echo "Making CTAN zip file"
	mkdir -p tmp/
	rm -rf tmp/*
	mkdir -p tmp/$(PACKAGE)/latex/bbx
	mkdir -p tmp/$(PACKAGE)/latex/cbx
	mkdir -p tmp/$(PACKAGE)/doc/examples
	for I in $(DOCS) ; do \
	  cp $$I.bib tmp/$(PACKAGE)/doc/examples/ ; \
	  cp $$I.pdf tmp/$(PACKAGE)/doc/          ; \
	  cp $$I.tex tmp/$(PACKAGE)/doc/          ; \
	done
	for I in $(STYLES) ; do \
	  cp $$I.bbx tmp/$(PACKAGE)/latex/bbx/          ; \
	  cp $$I.cbx tmp/$(PACKAGE)/latex/cbx/          ; \
	  cp style-$$I.pdf tmp/$(PACKAGE)/doc/examples/ ; \
	  cp style-$$I.tex tmp/$(PACKAGE)/doc/examples/ ; \
	done
	cp README tmp/$(PACKAGE)
	cp README tmp/$(PACKAGE)/doc
	cp $(PACKAGE).tds.zip tmp/
	cd tmp ; \
	zip -ll -q -r -X ../$(PACKAGE).zip .
	rm -rf tmp

doc:
	echo "Compling documents"
	for I in $(DOCS) ; do \
	  pdflatex -draftmode -interaction=nonstopmode $$I &> /dev/null ; \
	  bibtex8 --wolfgang $$I               &> /dev/null ; \
	  pdflatex -nonstopmode $$I            &> /dev/null ; \
	  rm -rf $$I-blx.bib                                ; \
	done
	for I in $(STYLES) ; do \
	  pdflatex -draftmode -interaction=nonstopmode style-$$I &> /dev/null ; \
	  bibtex8 --wolfgang style-$$I               &> /dev/null ; \
	  pdflatex -interaction=nonstopmode style-$$I            &> /dev/null ; \
	  rm -rf style-$$I-blx.bib                                ; \
	done
	for I in $(AUXFILES) ; do \
	  rm -rf *.$$I ; \
	done  

localinstall:
	echo "Installing files"
	TEXMFHOME=`kpsewhich --var-value=TEXMFHOME` ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT) ; \
	rm -rf $$TEXMFHOME/tex/$(PACKAGEROOT)/* ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT)/bbx ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT)/cbx ; \
	cp *.bbx $$TEXMFHOME/tex/$(PACKAGEROOT)/bbx/ ; \
	cp *.cbx $$TEXMFHOME/tex/$(PACKAGEROOT)/cbx/ ; \
	texhash &> /dev/null
	
tds: doc
	echo "Making TDS structure"
	mkdir -p tds/
	rm -rf tds/*
	mkdir -p tds/tex/$(TDS)/bbx
	mkdir -p tds/tex/$(TDS)/cbx
	mkdir -p tds/doc/$(TDS)/examples
	for I in $(DOCS) ; do \
	  cp $$I.bib tds/doc/$(TDS)/examples/ ; \
	  cp $$I.pdf tds/doc/$(TDS)/          ; \
	  cp $$I.tex tds/doc/$(TDS)/          ; \
	done
	for I in $(STYLES) ; do \
	  cp $$I.bbx tds/tex/$(TDS)/bbx/            ; \
	  cp $$I.cbx tds/tex/$(TDS)/cbx/            ; \
	  cp style-$$I.pdf tds/doc/$(TDS)/examples/ ; \
	  cp style-$$I.tex tds/doc/$(TDS)/examples/ ; \
	done
	cp README tds/doc/$(TDS)/
	cd tds ; \
	zip -ll -q -r -X ../$(PACKAGE).tds.zip .
	rm -rf tds