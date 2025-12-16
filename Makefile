# wordnet-prolog utilities (c) 2017-20 Eric Kafe
# License: CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

# 2025-12: extended for others Prolog systems (swi, gprolog, tpl)
# For gprolog set:
# export LOCALSZ=200000
# export TRAILSZ=100000
# export GLOBALSZ=700000
# export MAX_ATOM=500000


PL ?= swi

# --- fonctions to run Prolog on given file and halt ---
define run_swi
swipl -g 'halt' $(1)
endef

define run_gprolog
gprolog --init-goal "consult('$(1)'), halt"
endef

define run_tpl
tpl -g 'halt' $(1)
endef


# Add others Prolog system here

# -----------------------------------------------------


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
	@echo "Testing example queries with $(PL)..."
	@$(call run_$(PL),wn_query.pl)

valid:
	@echo "Checking symmetry and asymmetry with $(PL)..."
	@$(call run_$(PL),wn_valid.pl)

csv:
	@mkdir csv
	@echo "Converting Prolog databases to CSV with $(PL)..."
	@$(call run_$(PL),wn2csv.pl)

cleanpl:
	@echo Deleting Prolog output
	@rm -rf a.out
#	@rm -rf output/wn*Output*

cleancsv:
	@echo Deleting CSV files
	@rm -rf csv

clean: cleanpl cleancsv
