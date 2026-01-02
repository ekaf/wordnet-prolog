# -----------------------------------------------------------------------------
# https://github.com/ekaf/wordnet-prolog/raw/master/Makefile
# Copyright 2017-26 Eric Kafe
# SPDX-License-Identifier: Apache-2.0
# Licensed under the Apache License, Version 2.0
# -----------------------------------------------------------------------------

# 2025-12: extended by Daniel Diaz for other Prolog systems (swi, gprolog, tpl)

PL ?= swi

# --- functions to run Prolog on given file and halt ---
define run_swi
swipl -q -s $(1) -g 'halt'
endef

define run_gprolog
# Needs to allocate sufficient memory:
LOCALSZ=200000 \
TRAILSZ=100000 \
GLOBALSZ=700000 \
MAX_ATOM=600000 \
gprolog --init-goal "consult('$(1)'), halt"
endef

define run_tpl
tpl -q -g 'halt' $(1)
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

csv: cleancsv
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
