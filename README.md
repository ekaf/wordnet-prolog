# wordnet-prolog

https://github.com/ekaf/wordnet-prolog

*Wordnet-prolog* includes new versions of the _WNprolog_ databases,
compiled by Eric Kafe (https://github.com/ekaf/wordnet-prolog).
and bundled with a copy of the original WNprolog-3.0 documentation
(c) 2012 Princeton University.

## WNprolog-EWN-2020

WNprolog-EWN-2020 is a Prolog version of English WordNet 2020.

The Prolog databases were generated from the "April 21" wndb export,
retrieved from:

https://en-word.net/static/english-wordnet-2020.zip


This version avoids duplicates, and contains only unique clauses:

    7994 wn_ant.pl
    1278 wn_at.pl
    9620 wn_cls.pl
     221 wn_cs.pl
   74781 wn_der.pl
     408 wn_ent.pl
   21788 wn_fr.pl
  120053 wn_g.pl
   91454 wn_hyp.pl
    8589 wn_ins.pl
   12292 wn_mm.pl
    9201 wn_mp.pl
     830 wn_ms.pl
    8070 wn_per.pl
      73 wn_ppl.pl
    4100 wn_sa.pl
   21466 wn_sim.pl
  211940 wn_sk.pl
  211940 wn_s.pl
    1051 wn_syntax.pl
    1748 wn_vgp.pl
  818897 total

## Other Prolog versions of WordNet

The wordnet-prolog repository also includes alternative branches
with Prolog versions of WordNet 3.0 and WordNet 3.1.

## Utilities:

_wn_valid.pl_ is a SWI-prolog program testing for some potential issues in WordNet:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- antisymcheck: direct loops in the antisymmetric relations
- hypself: self-hyponymous word forms


The accompanying _wn_query.pl_ file is a SWI-prolog program
implementing some common WordNet use cases, and a few formal checks,
like symmetry and transitive loop detection.


For convenient inter-operation with other projects,
the included  _pl2csv_ and _csv2tab_ scripts convert the
Prolog databases to repectively comma- and tab-separated CSV files,
which can be easily imported into most database systems.

Type "make valid" or "make query" to run the SWI-prolog programs,
or "make csv" to generate CSV databases.
