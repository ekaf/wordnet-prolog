# wordnet-prolog

https://github.com/ekaf/wordnet-prolog

*Wordnet-prolog* includes new versions of the _WNprolog_ databases,
compiled by Eric Kafe (https://github.com/ekaf/wordnet-prolog).
and bundled with a copy of the original WNprolog-3.0 documentation
(c) 2012 Princeton University.

## WNprolog-3.1

WNprolog-3.1 is a Prolog version of WordNet 3.1.
The Prolog databases were generated from the original
WordNet 3.1 databases (c) 2011 Princeton University,

Some missing links were added, in order to enforce full
symmetry of the symmetric relations. Also, this version
avoids duplicates, and contains only unique clauses:

- wn_ant.pl: 7988
- wn_at.pl: 1278
- wn_cls.pl: 9559
- wn_cs.pl: 221
- wn_der.pl: 74781
- wn_ent.pl: 408
- wn_fr.pl: 21684
- wn_g.pl: 117791
- wn_hyp.pl: 89172
- wn_ins.pl: 8589
- wn_mm.pl: 12288
- wn_mp.pl: 9111
- wn_ms.pl: 797
- wn_per.pl: 8074
- wn_ppl.pl: 73
- wn_sa.pl: 4054
- wn_sim.pl: 21434
- wn_sk.pl: 207272
- wn_s.pl: 207272
- wn_syntax.pl: 1054
- wn_vgp.pl: 1744
- total: 804644

## Other Prolog versions of WordNet

The wordnet-prolog repository also includes alternative branches
with Prolog versions of WordNet 3.0 and English WordNet 2020.

## Utilities:

_wn_valid.pl_ is a SWI-prolog program testing for some potential issues in WordNet:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- antisymcheck: direct loops in the antisymmetric relations
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
