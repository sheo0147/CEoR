#
# Makefile for CEoR
#
# @(#) CEoR Document Makefile
#

.SUFFIXES: .DOKU .md

all: docs

clean:
	rm ../README.md ../README.en.md

docs: ../README.md ../README_en.md

../README.md: README.DOKU
	cat $< | sed -f doku2md.sed > $@

../README_en.md: README_en.DOKU
	cat $< | sed -f doku2md.sed > $@
