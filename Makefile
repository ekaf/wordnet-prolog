# wordnet-prolog utilities (c) 2017 Eric Kafe
# License: CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

all:
	@echo Setting executable permissions
	@chmod a+x pl2csv csv2tab
	./pl2csv
	./csv2tab

