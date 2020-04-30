# wordnet-prolog utilities (c) 2017-20 Eric Kafe
# License: CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

all: valid query csv

query:
	@echo Testing example queries...
	swipl -c wn_query.pl

valid:
	@echo Checking symmetry and antisymmetry ...
	swipl -c wn_valid.pl

csv:
	@chmod a+x pl2csv
	@echo Converting Prolog databases to CSV
	./pl2csv
# Uncomment to also get TAB-formattted files:
#	@chmod a+x csv2tab
#	@echo Converting CSV databases to TAB
#	./csv2tab

cleanpl:
	@echo Deleting Prolog output
	@rm a.out
#	@rm output/wn*Output*

cleancsv:
	@echo Deleting CSV files
	@rm -r csv

clean: cleanpl cleancsv
