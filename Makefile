LSP-STYLES=~/Documents/Dienstlich/Projekte/OALI/Git-HUB/latex/langsci/
BIBTOOL=bibtool-Mac
STYLE-PATH= ${HOME}/Library/texmf/tex/latex/


all: grammatical-theory.pdf

# Barbaras MacBook Pro (second generation) mit VM Ware 1.0 und Suse 10.2 32bit
# 1:14.09

# Dell Inspiron 8600 mit Suse 10.3 beta 1: 
# 1:31.98, 1:49.75, 1:55.48

# Stefans MacBook Pro (third generation) mit VM Ware 1.0 und Suse 10.2 64bit
# 7200er Platte 
# 1:17.79, 1:15.88

# Stefans MacBook Pro (third generation) mit VM Ware 1.0 und Suse 10.2 64bit
# 4200er Platte
#
# 1:24, 0:50

testtime:
	latex grammatical-theory-eng.tex; latex grammatical-theory-eng.tex; latex grammatical-theory-eng.tex; dvips grammatical-theory-eng.dvi; ps2pdf grammatical-theory-eng.ps

SOURCE=/Users/stefan/Documents/Dienstlich/Bibliographien/biblio.bib \
	grammatical-theory.tex           \
	grammatical-theory-include.tex   \
	localmetadata.tex \
	localcommands.tex \
	localpackages.tex \
	backmatter.tex \
	langscibook.cls \
        $(wildcard chapters/*.tex)	

.SUFFIXES: .tex


# there are two different index.format files.
# they contain special characters for delimination. Standard is ", but this is used
# for German. "+" is used as operator in the book and appears in the index of symbols.
# So I use "." as a separator for the subject index and "+" as separator for the authors index.
# St. Mü. 16.02.2016

# Since having the references missing results in different page layout
# \addlines throws errors. These are skipped with nonstopmode
# no, I rather call addlines in draft mode and make sure before that it 
# works properly.

# one extra cycle is needed for addlines to stabalize ....


# bib is stable now and is included
# does not work, since authorindex needs bib in .aux
# %.pdf: %.tex $(SOURCE)
# 	\rm -f $*.bbl
# 	xelatex -no-pdf -interaction=nonstopmode $* |grep -v math
# 	xelatex -no-pdf -interaction=nonstopmode $* 
# 	correct-toappear
# 	correct-index
# 	\rm $*.adx
# 	authorindex -i -p $*.aux > $*.adx
# 	sed -e 's/}{/|hyperpage}{/g' $*.adx > $*.adx.hyp
# 	makeindex -gs index.format-plus -o $*.and $*.adx.hyp
# 	makeindex -gs index.format -o $*.lnd $*.ldx
# 	makeindex -gs index.format -o $*.snd $*.sdx
# 	xelatex $* | egrep -v 'math|PDFDocEncod|microtype' |egrep 'Warning|label|aux'

#	\rm -f $*.bbl
#	bibtex  -min-crossrefs=200 $*
# %.pdf: %.tex $(SOURCE)
# 	xelatex -no-pdf -interaction=nonstopmode $* |grep -v math
# 	biber $*
# 	xelatex -no-pdf -interaction=nonstopmode $* 
# 	biber $*
# 	xelatex -no-pdf -interaction=nonstopmode $*
# 	correct-index
# 	\rm $*.adx
# 	authorindex -i -p $*.aux > $*.adx
# 	sed -e 's/}{/|hyperpage}{/g' $*.adx > $*.adx.hyp
# 	makeindex -gs index.format-plus -o $*.and $*.adx.hyp
# 	makeindex -gs index.format -o $*.lnd $*.ldx
# 	makeindex -gs index.format -o $*.snd $*.sdx
# 	xelatex $* | egrep -v 'math|PDFDocEncod|microtype' |egrep 'Warning|label|aux'


%.pdf: %.tex $(SOURCE)
	xelatex -no-pdf -interaction=nonstopmode $* |grep -v math
	biber $*
	xelatex -no-pdf -interaction=nonstopmode $* 
	biber $*
	xelatex -no-pdf -interaction=nonstopmode $*
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.sdx # ordering of references to footnotes
#	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.adx
#	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.ldx
#	sed -i.backup 's/\\protect \\active@dq \\dq@prtct {=}/"=/g' *.adx
#	sed -i.backup 's/{\\O }/Oe/' *.adx
	sed -i.backup 's/\\MakeCapital //g' *.adx
	sed -i.backup 's/.*Group.*//' grammatical-theory.adx
	python3 fixindex.py $*.adx
	mv $*mod.adx $*.adx
	makeindex -gs index.format-plus -o $*.and $*.adx
	makeindex -gs index.format -o $*.lnd $*.ldx
	makeindex -gs index.format -o $*.snd $*.sdx
	xelatex $* | egrep -v 'math|PDFDocEncod|microtype' |egrep 'Warning|label'

# use texfot instead?

# %.pdf: %.tex $(SOURCE)
# 	xelatex -no-pdf -interaction=nonstopmode $* |grep -v math
# 	bibtex  -min-crossrefs=200 $*
# 	xelatex -no-pdf -interaction=nonstopmode $* 
# 	bibtex  -min-crossrefs=200 $*
# 	xelatex -no-pdf -interaction=nonstopmode $*
# 	correct-toappear
# 	correct-index
# 	\rm $*.adx
# 	authorindex -i -p $*.aux > $*.adx
# 	sed -e 's/}{/|hyperpage}{/g' $*.adx > $*.adx.hyp
# 	makeindex -gs index.format-plus -o $*.and $*.adx.hyp
# 	makeindex -gs index.format -o $*.lnd $*.ldx
# 	makeindex -gs index.format -o $*.snd $*.sdx
# 	xelatex $* 


#	xelatex $* -no-pdf -interaction=nonstopmode

bbl:
	xelatex -no-pdf -interaction=nonstopmode grammatical-theory
	bibtex  -min-crossrefs=200 grammatical-theory
	correct-toappear

#	xelatex $* -no-pdf |egrep -v 'math|PDFDocEncod|microtype' |egrep 'Warning|label|aux'


# idx = author index
# ldx = language
# sdx = subject

# mit biblatex
#	makeindex -gs index.format -o $*.ind $*.idx


#	\rm $*.adx
#	authorindex -i -p $*.aux > $*.adx
#	sed -e 's/}{/|hyperpage}{/g' $*.adx > $*.adx.hyp
#	makeindex -gs index.format -o $*.and $*.adx.hyp
#	xelatex $* | egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'

index:
	xelatex grammatical-theory -no-pdf |egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'
	makeindex -gs index.format -o grammatical-theory.snd grammatical-theory.sdx
	xelatex grammatical-theory |egrep -v 'math|PDFDocEncod' |egrep 'Warning|label'


# mit neu langsci.cls
# %.pdf: %.tex $(SOURCE)
# 	xelatex -no-pdf $* |grep -v math
# 	bibtex $*
# 	xelatex -no-pdf $* |grep -v math
# 	bibtex $*
# 	xelatex $* -no-pdf |egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'
# 	correct-toappear
# 	correct-index
# 	sed -i s/.*\\emph.*// lsp-skeleton.adx #remove titles which biblatex puts into the name index
# 	makeindex -o $*.and $*.adx
# 	makeindex -o $*.lnd $*.ldx
# 	makeindex -o $*.snd $*.sdx
# 	xelatex $* | egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'


stable.pdf: main.pdf
	cp main.pdf stable.pdf


# http://stackoverflow.com/questions/10934456/imagemagick-pdf-to-jpgs-sometimes-results-in-black-background
cover: grammatical-theory.pdf
	convert $<\[0\] -resize 486x -background white -alpha remove -bordercolor black -border 2  cover.png


# fuer Sprachenindex
#	makeindex -gs index.format -o $*.lnd $*.ldx


lsp-styles:
	rsync -a $(LSP-STYLES) langsci




public: grammatical-theory.pdf
	cp $? /Users/stefan/public_html/Pub/


/Users/stefan/public_html/Pub/grammatical-theory.pdf: grammatical-theory.pdf
	cp -p $?                      /Users/stefan/public_html/Pub/grammatical-theory.pdf


commit:
	svn commit -m "published version to the web"

# to eliminate the risk of jumping trees build the complete pdf without
# memozation (main.tex does load nomemoize) and then latex compile-memos-grammatical-theory.tex
# (which does load memoize, ignores \addlines and does not have the bibliography compiled) and call the extraction script after this.
memos: cleanmemo main.pdf
	xelatex -shell-escape compile-memos-grammatical-theory
	python3 memomanager.py split compile-memos-grammatical-theory.mmz


memo-install:
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/memoize* .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/nomemoize* .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/xparse-arglist.sty .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/memomanager.py .

forest-install:
	cp -pr ~/Documents/Dienstlich/Projekte/LangSci/Git-Hub/latex/langsci-forest-setup.sty .

stmue-install:
	cp -p ${STYLE-PATH}makros.2e.sty                   styles/
	cp -p ${STYLE-PATH}abbrev.sty                        styles/
	cp -p ${STYLE-PATH}eng-date.sty                      styles/
	cp -p ${STYLE-PATH}eng-hyp-utf8.sty                  styles/
	cp -p ${STYLE-PATH}mycommands.sty                    styles/
	cp -p ${STYLE-PATH}biblatex-series-number-checks.sty styles/
	cp -p ${STYLE-PATH}Ling/article-ex.sty               styles/
	cp -p ${STYLE-PATH}Ling/merkmalstruktur.sty          styles/


o-public: o-public-lehrbuch 
#o-public-bib

o-public-lehrbuch: /Users/stefan/public_html/Pub/grammatical-theory.pdf 
	scp -p $? home.hpsg.fu-berlin.de:/home/stefan/public_html/Pub/


# two runs in order to get "also printed as ..." right
# biber changes everything
unusedgt1.bib: ../../../Bibliographien/biblio.bib
	xelatex -no-pdf -interaction=nonstopmode bib-creation 
	biber bib-creation
	xelatex -no-pdf -interaction=nonstopmode bib-creation 
	biber --output_format=bibtex --output_resolve bib-creation.bcf -O gt_tmp.bib
	biber --tool --configfile=biber-tool-test.conf gt_tmp.bib -O gt.bib


bib: gt.bib

# We need a special .tex file loading biblio.bib to create gt.bib.
# We cannot derive it from grammatical-theory.tex since this loads gt.bib.

# two runs in order to get "also printed as ..." right
# biber --tool removes unwanted fields (annotation, abstract)
# explanation of bbl2nocite and stuff: https://tex.stackexchange.com/a/164365/18561
unusedgt.bib: ../../../Bibliographien/biblio.bib $(SOURCE)
	xelatex -no-pdf -interaction=nonstopmode -shell-escape bib-creation 
	biber -m=1 bib-creation.bcf       # `--mincrossref | -m 1` produces a .bbl with all the references 
	bbl2nocite bib-creation tmpfile
	xelatex -no-pdf -interaction=nonstopmode -shell-escape bib-creation 
	biber --output_format=bibtex bib-creation.bcf -O gt_tmp.bib
	biber --tool --configfile=biber-tool-test.conf gt_tmp.bib -O gt.bib

# --output_resolve removes all crossrefs if one wants crossref, one needs this:
# https://tex.stackexchange.com/a/164365/18561


# xelatex has to be run two times + biber to get "also printed as ..." right.
gt.bib: ../../../Bibliographien/biblio.bib $(SOURCE) langsci.dbx bib-creation.tex
	xelatex -no-pdf -interaction=nonstopmode -shell-escape bib-creation 
	biber bib-creation
	xelatex -no-pdf -interaction=nonstopmode -shell-escape bib-creation
	biber --output_format=bibtex --output-resolve-xdata --output-legacy-date bib-creation.bcf -O gt_tmp.bib
	biber --tool --configfile=biber-tool.conf --output-field-replace=location:address,journaltitle:journal --output-legacy-date gt_tmp.bib -O gt.bib


check-gt.bib: ../../../Bibliographien/biblio.bib
	biber --output_format=bibtex --output_resolve grammatical-theory.bcf -O check-gt.bib


check-bib: gt.bib 
	biber --validate-datamodel grammatical-theory

# what do you have to do after changing langsci.dbx? Everything?
grammatical-theory.bcf: langsci.dbx ../../../Bibliographien/biblio.bib
	xelatex grammatical-theory
	biber grammatical-theory

todo-bib.unique.txt: grammatical-theory.bcf
	biber -V grammatical-theory | grep -i warn | sort -uf > todo-bib.unique.txt



PUB_FILE=stmue.bib

o-public-bib: $(PUB_FILE)
	scp -p $? home.hpsg.fu-berlin.de:/home/stefan/public_html/Pub/






#-f '(author){%n(author)}{%n(editor)}:{%2d(year)#%s(year)#no-year}'

#$(IN_FILE).dvi

# la.tex does not compile any longer
# ../../hpsg/la.aux

$(PUB_FILE): ../../hpsg/make_bib_header ../../hpsg/make_bib_html_number ../../hpsg/.bibtool77-no-comments grammatical-theory.aux ../../hpsg/la.aux ../../HPSG-Lehrbuch/hpsg-lehrbuch-4.aux ../../complex/complex-csli.aux ../../../Bibliographien/biblio.bib
	cat bib-creation.aux  ../../HPSG-Lehrbuch/hpsg-lehrbuch-4.aux ../../complex/complex-csli.aux >tmp.aux
	sed -i.backup 's/bibcite{\([A-Za-z0-9-]*\)}\(.*\)/bibcite{\1}/' tmp.aux
	sort -u tmp.aux  >tmp2.aux
	$(BIBTOOL) -r ../../hpsg/.bibtool77-no-comments  -x tmp2.aux -o $(PUB_FILE).tmp
	sed -e 's/-u//g'  $(PUB_FILE).tmp  >$(PUB_FILE).tmp.neu
	../../hpsg/make_bib_header
	cat bib_header.txt $(PUB_FILE).tmp.neu > $(PUB_FILE)
	rm $(PUB_FILE).tmp $(PUB_FILE).tmp.neu


source: 
	tar chzvf ~/Downloads/gt.tgz *.tex styles/*.sty LSP/


clean:
	rm -f *.bak *~ *.log *.blg *.bbl *.aux *.toc *.cut *.out *.tpm *.adx *.idx *.ilg *.ind \
	*.and *.glg *.glo *.gls *.657pk *.adx.hyp *.bbl.old *.ldx *.lnd *.rdx *.sdx *.snd *.wdx \
	*.wdv *.xdv chapters/*.aux *.aux.copy *-blx.bib *.auxlock *.bcf *.mw *.run.xml *.backup \
	chapters/*.aux chapters/*.log chapters/*.aux.copy chapters/*.old chapters/*~ chapters/*.bak chapters/*.backup \
	langsci/*/*.aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup \


check-clean:
	rm -f *.bak *~ *.log *.blg complex-draft.dvi

cleanmemo:
	rm -f *.mmz *.memo.dir/*

brutal-clean: clean cleanmemo


#realclean: clean
#	rm -f *.dvi *.ps *.pdf
#	cp langsci-graphics/ccby.pdf .



