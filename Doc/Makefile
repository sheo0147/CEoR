#
# Makefile for CEoR
#
# @(#) CEoR Document Makefile
#

.SUFFIXES: .DOKU .md

all: docs

clean:
	rm ../README.md ../README.en.md ../INSTALL.md

docs: ../README.md ../README_en.md ../INSTALL.md

../README.md: README.DOKU
	cat $< | sed -f doku2md.sed > $@

../README_en.md: README_en.DOKU
	cat $< | sed -f doku2md.sed > $@

../INSTALL.md: INSTALL.DOKU
	cat $< | sed -f doku2md.sed > $@
