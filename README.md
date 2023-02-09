# wordnet-prolog

https://github.com/ekaf/wordnet-prolog

*Wordnet-prolog* includes new versions of the _WNprolog_ databases,
compiled by Eric Kafe (https://github.com/ekaf/wordnet-prolog),
and bundled with a copy of the original WNprolog-3.0 documentation
(c) 2012 Princeton University.

## WNprolog-OEWN-2022

WNprolog-EWN-2022 is a Prolog version of Open English WordNet, Edition 2022.

The Prolog databases were generated from the official "wndb" export,
retrieved from:

https://en-word.net/static/english-wordnet-2022.zip


This version avoids duplicates, and contains only unique clauses:

 - 8000 wn_ant.pl
 - 1278 wn_at.pl
 - 10536 wn_cls.pl
 - 221 wn_cs.pl
 - 74688 wn_der.pl
 - 408 wn_ent.pl
 - 4467 wn_exc.pl
 - 21780 wn_fr.pl
 - 120068 wn_g.pl
 - 91551 wn_hyp.pl
 - 8590 wn_ins.pl
 - 12296 wn_mm.pl
 - 9199 wn_mp.pl
 - 830 wn_ms.pl
 - 8072 wn_per.pl
 - 73 wn_ppl.pl
 - 4100 wn_sa.pl
 - 21450 wn_sim.pl
 - 212009 wn_sk.pl
 - 212009 wn_s.pl
 - 1052 wn_syntax.pl
 - 1736 wn_vgp.pl
 - 824413 total

## Other Prolog versions of WordNet

The wordnet-prolog repository also includes alternative branches
with Prolog versions of WordNet 3.0, WordNet 3.1, and Open English Wordnet.

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
