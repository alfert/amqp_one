SHELL=/bin/bash
XML=overview.xml types.xml transport.xml messaging.xml transactions.xml security.xml

UNAME:= $(shell uname -s)
DOCUMENT:= $(shell xsltproc xsl/document.xsl front-matter/metadata.xml)
VERSION:= $(shell xsltproc xsl/version.xsl front-matter/metadata.xml)
DOCVERSION:= $(shell xsltproc xsl/docversion.xsl front-matter/metadata.xml)
MKDIROPT=-p


TOOLS=xsl
XML2HTML=${TOOLS}/xml2html.xsl
XML2LATEX=${TOOLS}/xml2latex.xsl
XML2XML=${TOOLS}/xml2xml.xsl

LATEX=pdflatex
CP=cp
SEP=;
QUOTE='
ALTQUOTE="
FS=/
SEDSCRIPT='s/ / /'

ifeq ($(UNAME), Darwin)
LATEX=/Applications/TeX/TeXShop.app/Contents/Resources/TeXShop/bin/pdflatexc
endif

ifeq ($(UNAME), windows32)
CP=copy
SEP=&
QUOTE="
ALTQUOTE='
MKDIROPT=
FS=\\
SEDSCRIPT="s/^.\(.*>\)[^ <]/\1/"
endif

OUTPUT=output
SPEC=specification
TEMP=${OUTPUT}${FS}temp
INDEX=${SPEC}${FS}index.xml

SPECXML=$(XML:%.xml=${SPEC}/%.xml)
INDEXXML=$(XML:%.xml=<li><p><xref type="amqp" name="%"/></p></li>)
HTML=$(XML:%.xml=${TEMP}/%.html)
TEX=$(XML:%.xml=${TEMP}/%.tex)
PDF=$(XML:%.xml=${TEMP}/%.pdf)
OUTPUTXML=$(XML:%.xml=${TEMP}/%.xml)

DTD=${SPEC}${FS}amqp.dtd

FINALOUTPUT=${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}
FINALHTML=${XML:%.xml=${FINALOUTPUT}/${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.html}
FINALPDF=${XML:%.xml=${FINALOUTPUT}/${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.pdf}
FINALXML=${XML:%.xml=${FINALOUTPUT}/${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.xml}
COMPLETEPDF=${FINALOUTPUT}/${DOCUMENT}-complete-v${VERSION}-${DOCVERSION}.pdf}
GT=>
LT=<
IMAGES=..${FS}oasis.jpg 

all: html xml ${FINALHTML} ${FINALXML} ${COMPLETEPDF}

tgz: ${TGZ}

html: prepare $(SPECXML) ${HTML}

tex: prepare $(SPECXML) ${TEX}

xml: prepare ${OUTPUTXML}

pdf: prepare $(SPECXML) ${COMPLETEPDF}

prepare: ${IMAGES} 
	@-mkdir ${MKDIROPT} ${SPEC}
	@-mkdir ${MKDIROPT} ${OUTPUT}
	@-mkdir ${MKDIROPT} ${TEMP}
	@-mkdir ${MKDIROPT} ${SPEC}
	@${CP} ${IMAGES} ${TEMP}
	@${CP} ..${FS}amqp.dtd ${SPEC}
	@${CP} front-matter${FS}*.xml ${OUTPUT}
	@echo ${QUOTE}<amqp name=${ALTQUOTE}index${ALTQUOTE} label=${ALTQUOTE}index${ALTQUOTE}> <doc> <ul>${QUOTE} | sed -e ${SEDSCRIPT} > ${INDEX}
	@echo ${QUOTE}${INDEXXML}${QUOTE}  | sed -e ${SEDSCRIPT} >> ${INDEX}
	@echo ${QUOTE}</ul></doc></amqp>${QUOTE}  | sed -e ${SEDSCRIPT} >> ${INDEX}


${SPEC}/%.xml: ../amqp-core-%-v${VERSION}-${DOCVERSION}.xml
	@${CP} $(<:../amqp-core-%-v${VERSION}-${DOCVERSION}.xml=..${FS}amqp-core-%-v${VERSION}-${DOCVERSION}.xml) $(@:${SPEC}/%.xml=${SPEC}${FS}%.xml)
	
${SPEC}/%.dtd: ../amqp.dtd
	@${CP} $(<) $@

${TEMP}/complete.tex: ${SPECXML} ${XML2LATEX}
	@xsltproc --path ${SPEC} --stringparam completeDoc true -o $@ ${XML2LATEX} index.xml

${TEMP}/complete.pdf: ${TEMP}/complete.tex prepare
	@pushd ${TEMP} ${SEP} ${LATEX} complete.tex ${SEP} ${LATEX} complete.tex ${SEP} ${LATEX} complete.tex ${SEP}	popd

${TEMP}/%.xml: ${SPEC}/%.xml ${XML2XML}
	@xsltproc --path ${SPEC} -o $@ ${XML2XML} $<

${TEMP}/%.html: ${SPEC}/%.xml ${XML2HTML}
	@xsltproc --path ${SPEC} -o $@ ${XML2HTML} $<

${FINALOUTPUT}/${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.html: ${TEMP}/%.html
	@-mkdir ${MKDIROPT} ${OUTPUT}${FS}v${VERSION}
	@-mkdir ${MKDIROPT} ${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}
	@${CP} ${IMAGES} ${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}
	@${CP} $(<:${TEMP}/%.html=${OUTPUT}${FS}temp${FS}%.html) $(<:${TEMP}/%.html=${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}${FS}${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.html)

${FINALOUTPUT}/${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.pdf: ${TEMP}/%.pdf
	@-mkdir ${MKDIROPT} ${OUTPUT}${FS}v${VERSION}
	@-mkdir ${MKDIROPT} ${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}
	@${CP} $(<:${TEMP}/%.pdf=${OUTPUT}${FS}temp${FS}%.pdf) $(<:${TEMP}/%.pdf=${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}${FS}${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.pdf)

${FINALOUTPUT}/${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.xml: ${TEMP}/%.xml
	@-mkdir ${MKDIROPT} ${OUTPUT}${FS}v${VERSION}
	@-mkdir ${MKDIROPT} ${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}
	@${CP} ..${FS}amqp.dtd ${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}
	@${CP} $(<:${TEMP}/%.xml=${OUTPUT}${FS}temp${FS}%.xml) $(<:${TEMP}/%.xml=${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}${FS}${DOCUMENT}-%-v${VERSION}-${DOCVERSION}.xml)

${COMPLETEPDF}: ${TEMP}/complete.pdf
	@-mkdir ${MKDIROPT} ${OUTPUT}${FS}v${VERSION}
	@-mkdir ${MKDIROPT} ${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}
	@${CP} ${OUTPUT}${FS}temp${FS}complete.pdf ${OUTPUT}${FS}v${VERSION}${FS}${DOCVERSION}${FS}${DOCUMENT}-complete-v${VERSION}-${DOCVERSION}.pdf

clean:
	@-rm -rf output
	@-rm -rf specification
