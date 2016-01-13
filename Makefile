LSP-STYLES=~/Documents/Dienstlich/Projekte/OALI/Git-HUB/latex/LSP/

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
	chapters/1-begriffe.tex\
	chapters/2-psg.tex\
	chapters/3-gb.tex \
	chapters/3-minimalism.tex \
	chapters/4-gpsg.tex \
	chapters/5-merkmalstrukturen.tex \
	chapters/6-lfg.tex \
	chapters/7-cg.tex\
	chapters/8-hpsg.tex \
	chapters/9-cxg.tex \
	chapters/dg.tex\
	chapters/tag.tex\
	chapters/innateness.tex\
	chapters/acquisition.tex\
	chapters/complexity.tex\
	chapters/phrasal.tex\
	chapters/empty.tex\
	chapters/recursion.tex\
	chapters/conclusions.tex\
	chapters/loesungen.tex

.SUFFIXES: .tex


%.pdf: %.tex $(SOURCE)
	xelatex -no-pdf $* |grep -v math
	bibtex  -min-crossrefs=200 $*
	xelatex -no-pdf $* |grep -v math
	bibtex  -min-crossrefs=200 $*
	xelatex $* -no-pdf |egrep -v 'math|PDFDocEncod|microtype' |egrep 'Warning|label|aux'
	correct-toappear
	correct-index
	\rm $*.adx
	authorindex -i -p $*.aux > $*.adx
	sed -e 's/}{/|hyperpage}{/g' $*.adx > $*.adx.hyp
	makeindex -gs index.format -o $*.and $*.adx.hyp
	makeindex -gs index.format -o $*.lnd $*.ldx
	makeindex -gs index.format -o $*.snd $*.sdx
	xelatex $* | egrep -v 'math|PDFDocEncod|microtype' |egrep 'Warning|label|aux'


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
	xelatex grammatical-theory |egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'


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



# http://stackoverflow.com/questions/10934456/imagemagick-pdf-to-jpgs-sometimes-results-in-black-background
cover: grammatical-theory.pdf
	convert $<\[0\] -resize 486x -background white -alpha remove -bordercolor black -border 2  cover.png


# fuer Sprachenindex
#	makeindex -gs index.format -o $*.lnd $*.ldx


lsp-styles:
	rsync -a $(LSP-STYLES) LSP/




public: grammatical-theory.pdf
	cp $? /Users/stefan/public_html/Pub/


/Users/stefan/public_html/Pub/grammatical-theory.pdf: grammatical-theory.pdf
	cp -p $?                      /Users/stefan/public_html/Pub/grammatical-theory.pdf


commit:
	svn commit -m "published version to the web"

o-public: o-public-lehrbuch 
#o-public-bib

o-public-lehrbuch: /Users/stefan/public_html/Pub/grammatical-theory.pdf 
	scp -p $? home.hpsg.fu-berlin.de:/home/stefan/public_html/Pub/



PUB_FILE=stmue.bib

o-public-bib: $(PUB_FILE)
	scp -p $? home.hpsg.fu-berlin.de:/home/stefan/public_html/Pub/




#-f '(author){%n(author)}{%n(editor)}:{%2d(year)#%s(year)#no-year}'

#$(IN_FILE).dvi
$(PUB_FILE): ../hpsg/make_bib_header ../hpsg/make_bib_html_number  ../hpsg/.bibtool77-no-comments grammatical-theory.aux ../hpsg/la.aux ../HPSG-Lehrbuch/hpsg-lehrbuch.aux ../complex/complex-csli.aux 
	sort -u grammatical-theory.aux ../hpsg/la.aux ../HPSG-Lehrbuch/hpsg-lehrbuch.aux ../complex/complex-csli.aux  >tmp.aux
	bibtool -r ../hpsg/.bibtool77-no-comments  -x tmp.aux -o $(PUB_FILE).tmp
	sed -e 's/-u//g'  $(PUB_FILE).tmp  >$(PUB_FILE).tmp.neu
	../hpsg/make_bib_header
	cat bib_header.txt $(PUB_FILE).tmp.neu > $(PUB_FILE)
	rm $(PUB_FILE).tmp $(PUB_FILE).tmp.neu


source: 
	tar chzvf ~/Downloads/gt.tgz *.tex styles/*.sty LSP/


clean:
	rm -f *.bak *~ *.log *.blg *.bbl *.aux *.toc *.cut *.out *.tmp *.tpm *.adx *.idx *.ilg *.ind *.and *.glg *.glo *.gls *.657pk *.adx.hyp *.bbl.old *.ldx *.lnd *.rdx *.sdx *.snd *.wdx *.wdv *.xdv

check-clean:
	rm -f *.bak *~ *.log *.blg complex-draft.dvi

realclean: clean
	rm -f *.dvi *.ps *.pdf



