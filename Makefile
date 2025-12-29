# wordnet-prolog utilities (c) 2017-25 Eric Kafe
# SPDX-License-Identifier: Apache-2.0
# Licensed under the Apache License, Version 2.0

all: doc valid query csv

# Groff is required for building the documentation
doc: html pdf ps

html:
# Needs the 'groff' package
	@groff -mandoc -Thtml doc/prologdb.5>doc/prologdb.5WN.html

pdf:
# Needs the 'groff' package
	@groff -mandoc -Tpdf doc/prologdb.5>doc/prologdb.pdf

ps:
# Needs the 'groff' package
	@groff -mandoc -Tps doc/prologdb.5>doc/prologdb.ps

query:
	@echo Testing example queries...
	swipl -c wn_query.pl

valid:
	@echo Checking symmetry and asymmetry ...
	swipl -c wn_valid.pl

csv:
	@mkdir csv
	@echo Converting Prolog databases to CSV
	swipl -c wn2csv.pl

cleanpl:
	@echo Deleting Prolog output
	@rm a.out
#	@rm output/wn*Output*

cleancsv:
	@echo Deleting CSV files
	@rm -r csv

clean: cleanpl cleancsv
