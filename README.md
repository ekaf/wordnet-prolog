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

-    7988 wn_ant.pl
-    1278 wn_at.pl
-    9559 wn_cls.pl
-     221 wn_cs.pl
-   74781 wn_der.pl
-     408 wn_ent.pl
   21684 wn_fr.pl
  117791 wn_g.pl
   89172 wn_hyp.pl
    8589 wn_ins.pl
   12288 wn_mm.pl
    9111 wn_mp.pl
     797 wn_ms.pl
    8074 wn_per.pl
      73 wn_ppl.pl
    4054 wn_sa.pl
   21434 wn_sim.pl
  207272 wn_sk.pl
  207272 wn_s.pl
    1054 wn_syntax.pl
    1744 wn_vgp.pl
  804644 total

## Other Prolog versions of WordNet

The wordnet-prolog repository also includes alternative branches
with Prolog versions of WordNet 3.0 and English WordNet 2020.

## Utilities:

_wn_valid.pl_ is a SWI-prolog program testing for some potential issues in WordNet:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- antisymcheck: direct loops in the antisymmetric relations
- hypself: self-hyponymous word forms

The accompanying _wn_query.pl_ file is a SWI-prolog program
implementing some common WordNet use cases, and a few formal checks,
like symmetry and transitive loop detection.

For convenient inter-operation with other projects, the included  _pl2csv_ and _csv2tab_ scripts
convert the Prolog databases to repectively comma- and tab-separated CSV files, 
which can be easily imported into most database systems.

Type "make valid" or "make query" to run the SWI-prolog programs,
or "make csv" to generate CSV databases.
