# wordnet-prolog

https://github.com/ekaf/wordnet-prolog

*Wordnet-prolog* includes new versions of the _WNprolog_ databases,
compiled by Eric Kafe (https://github.com/ekaf/wordnet-prolog),
and bundled with a copy of the original WNprolog-3.0 documentation
(c) 2006 Princeton University.


## License

The code and logic in this repository are licensed under the **[Apache License 2.0](LICENSES/Apache-2.0.txt)**.

The WordNet documentation and database files in this release are subject to the following third-party license:
* **WordNet 3.1:** Distributed under the [Princeton WordNet License](LICENSES/WordNet.txt).

Full attribution details and copyright notices are maintained in the **[NOTICE](NOTICE)** file.


## WNprolog-3.0BF

WNprolog-3.0BF is a bugfix release of WNprolog-3.0.
The Prolog databases were generated from the original
WordNet 3.0 databases (c) 2006 Princeton University,
after applying two patches that fix well-known bugs:

- wn3.0.diff by Bernard Bou, retrieved in 2007 from
http://heanet.dl.sourceforge.net/sourceforge/wnsqlbuilder/wn3.0.diff

- WN3.loop.patch by Benjamin Haskell, retrieved in 2007 from
http://wordnet.princeton.edu/~ben/WN3.loop.patch

Additionally, this version enforces full symmetry of
the symmetric relations by adding some missing links.

Furthermore, the first WNprolog-3.0 release included
the following numbers of duplicate clauses, concerning 
7 noun synsets (in wn_der.pl), and 3621 adverb synsets:

- wn_ant.pl: 710
- wn_cls.pl: 110
- wn_der.pl: 10
- wn_g.pl: 3621
- wn_per.pl: 3222
- wn_sk.pl: 5580
- wn_s.pl: 5580
- total: 18833


The present release avoids these duplicates, and contains
only unique facts:

- wn_ant.pl: 7984
- wn_at.pl: 1278
- wn_cls.pl: 9390
- wn_cs.pl: 220
- wn_der.pl: 74821
- wn_ent.pl: 408
- wn_exc.pl: 6050
- wn_fr.pl: 21647
- wn_g.pl: 117659
- wn_hyp.pl: 89089
- wn_ins.pl: 8577
- wn_mm.pl: 12293
- wn_mp.pl: 9097
- wn_ms.pl: 797
- wn_per.pl: 8022
- wn_ppl.pl: 73
- wn_sa.pl: 4046
- wn_sim.pl: 21386
- wn_sk.pl: 206978
- wn_s.pl: 206978
- wn_syntax.pl: 1055
- wn_vgp.pl: 1750
- total: 809598



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
- Add SPDX license and copyright tags
