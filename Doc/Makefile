#
# Makefile for CEoR
#
# @(#) CEoR Document Makefile
#

all: docs

clean:
	rm README.md

docs: README.md

README.md: ../README.DOKU
	cat ../README.DOKU | sed -f doku2md.sed > ../README.md
