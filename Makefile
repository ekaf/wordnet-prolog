# wordnet-prolog utilities (c) 2017-20 Eric Kafe
# License: CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

all: doc valid query csv

doc: html pdf ps

html:
	@groff -mandoc -Thtml doc/prologdb.5>doc/prologdb.5WN.html

pdf:
	@groff -mandoc -Tpdf doc/prologdb.5>doc/prologdb.pdf

ps:
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
