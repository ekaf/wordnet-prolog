# wordnet-prolog

https://github.com/ekaf/wordnet-prolog

*Wordnet-prolog* includes new versions of the _WNprolog_ databases,
compiled by Eric Kafe (https://github.com/ekaf/wordnet-prolog),
and bundled with a copy of the original WNprolog-3.0 documentation
(c) 2012 Princeton University.

## License

This branch contains software and data under multiple licenses:

- **Code:**
  - Licensed under the **Apache License 2.0**. See [LICENSE](LICENSE).

- **Open English WordNet (OEWN) data:**
  - Original WordNet data: Licensed under the **Princeton WordNet License**. See [LICENSE-WORDNET](LICENSE-WORDNET).
  - Modifications and additions: Licensed under the **Creative Commons Attribution 4.0 International License (CC-BY-4.0)**. See [LICENSE-CC-BY-4.0](LICENSE-CC-BY-4.0).

- **Documentation (`doc`):**
  - The `doc` directory contains portions of the original WordNet 3.0 documentation (© 2006 by Princeton University). It is fully licensed under the **Princeton WordNet License**.

See the [`NOTICE`](NOTICE) file for detailed license explanations and attribution requirements. Individual files also contain [SPDX headers](https://spdx.github.io/spdx-spec/) where applicable.


## WNprolog-OEWN-2025+

WNprolog-OEWN-2025+ is a Prolog version of Open English WordNet, Edition 2025+.

The Prolog databases were generated from the official "wndb" export,
retrieved from:

https://en-word.net/static/english-wordnet-2025-plus.zip

This version contains the following numbers of unique facts:

- wn_ant.pl: 7990
- wn_at.pl: 1278
- wn_cls.pl: 16591
- wn_cs.pl: 221
- wn_der.pl: 74606
- wn_ent.pl: 407
- wn_exc.pl: 4467
- wn_fr.pl: 21833
- wn_g.pl: 120565
- wn_hyp.pl: 93395
- wn_ins.pl: 8599
- wn_mm.pl: 12292
- wn_mp.pl: 9194
- wn_ms.pl: 826
- wn_per.pl: 8067
- wn_ppl.pl: 73
- wn_sa.pl: 4098
- wn_sim.pl: 21452
- wn_sk.pl: 203366
- wn_s.pl: 203366
- wn_syntax.pl: 929
- wn_vgp.pl: 1726
- total: 815341

## Other Prolog versions of WordNet

The wordnet-prolog repository also includes alternative branches
with Prolog versions of WordNet 3.0 and Open English WordNet 2022.

## Utilities:

_wn_morphy.pl_ is a SWI-prolog lemmatizer, similar to _morphy_,
the morphological processor from WordNet.

_wn_valid.pl_ is a SWI-prolog program testing for some potential issues in WordNet:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- asymcheck: direct loops in the asymmetric relations
- hypself: self-hyponymous word forms
- check_duplicates: find duplicate clauses


The accompanying _wn_query.pl_ file is a SWI-prolog program
implementing some common WordNet use cases, and a few formal checks,
like symmetry and transitive loop detection.


For convenient inter-operation with other projects, the _wn2csv.pl_ program
converts the Prolog databases to comma-separated CSV files,
which can be easily imported into most database systems.

Type "make valid" or "make query" to run the SWI-prolog programs,
or "make csv" to generate CSV databases.


## News (2020):

CSV versions of the WordNet databases (output by _wn2csv.pl_) are now
available through the _wncsv_ project at:

https://github.com/ekaf/wncsv

## News (2025):

- Added utils.pl: system-independent implementations of non-standard predicates.
- Added timeit.pl to time predicate calls.

The programs have been made less specific to SWI by Daniel Diaz and Eric Kafe.
To achieve this, we have favored ISO Prolog and commonly supported extensions
(such as format/2). The corresponding PRs (#8 and #10) include more info
about the changes.

The Makefile design has been revised so that the desired Prolog can be passed as
a parameter with:

make <target> PL=<system>

Currently, in addition to SWI Prolog (swi), GNU Prolog (gprolog) or Trealla
Prolog (tpl) can also be used. It should be easy to add support for other
systems.

For ex. to run wn_valid.pl with the default SWI-Prolog:

make valid

Or specify PL=gprolog to use gprolog instead of the default:

make valid PL=gprolog


## News (2026):

- Speed up the transitive relation closures, for ex. [_thyp_ in wn_query](wn_query.pl).
- Use no hard cut.
- Use call/N instead of univ (=..).
- Add loader.pl, to load files only once.
- Quote strings and fix quotes in CSV output.
- Unescape sense keys
- Add SPDX license and copyright tags
