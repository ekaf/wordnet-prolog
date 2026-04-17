# wordnet-prolog

https://github.com/ekaf/wordnet-prolog

*Wordnet-prolog* includes new versions of the _WNprolog_ databases,
compiled by Eric Kafe (https://github.com/ekaf/wordnet-prolog),
and bundled with a copy of the original WNprolog-3.0 documentation
(c) 2012 Princeton University.


## License

The code and logic in this repository are licensed under the **[Apache License 2.0](LICENSES/Apache-2.0.txt)**.

The WordNet documentation and database files in this release are subject to the following third-party license:
* **WordNet 3.1:** Distributed under the [Princeton WordNet License](LICENSES/WordNet.txt).

- **Open English WordNet (OEWN) data:**
  - Original WordNet data: Licensed under the **Princeton WordNet License**. See above.
  - Modifications and additions: Licensed under the **Creative Commons Attribution 4.0 International License (CC-BY-4.0)**. See [LICENSE-CC-BY-4.0](LICENSES/CC-BY-4.0.txt).


## WNprolog-3.1

See the [`NOTICE`](NOTICE) file for detailed license explanations and attribution requirements. Individual files also contain [SPDX headers](https://spdx.github.io/spdx-spec/) where applicable.

Some missing links were added, in order to enforce full
symmetry of the symmetric relations. Also, this version
avoids duplicates, and contains only unique facts:

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
- wn_sa.pl: 4054
- wn_sim.pl: 21434
- wn_sk.pl: 207272
- wn_s.pl: 207272
- wn_syntax.pl: 1054
- wn_vgp.pl: 1744
- total: 810697


## Other Prolog versions of WordNet

The wordnet-prolog repository also includes alternative branches
with Prolog versions of WordNet 3.0 and Open English Wordnet.

These are available for download as compressed packages,
from the Github Releases menu.


## Utilities:

The following are standard Prolog programs, intended for compatibility
with the ISO-Prolog standard:

_wn_morphy.pl_ is a Prolog lemmatizer, similar to _morphy_,
the morphological processor from WordNet.

_wn_valid.pl_ is a Prolog program testing for some potential issues in WordNet:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- asymcheck: direct loops in the asymmetric relations
- hypself: self-hyponymous word forms
- check_duplicates: find duplicate clauses


The accompanying _wn_query.pl_ file is a Prolog program
implementing some common WordNet use cases, and a few formal checks,
like symmetry and transitive loop detection.


For convenient inter-operation with other projects, the _wn2csv.pl_ program
converts the Prolog databases to comma-separated CSV files,
which can be easily imported into most database systems.

Type "make valid" or "make query" to run the Prolog programs,
or "make csv" to generate CSV databases.


## ChangeLog

### 2020

CSV versions of the WordNet databases (output by _wn2csv.pl_) are now
available through the _wncsv_ project at:

https://github.com/ekaf/wncsv


### 2025

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


### 2026

- Transitive relation closures in linear time
- Use no hard cut
- Use call/N instead of univ (=..)
- Add loader.pl, to load files only once
- Quote strings and fix quotes in CSV output
- Add SPDX license and copyright tags
- Improve portability
- Check portability with Github Action
