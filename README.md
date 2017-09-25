#wordnet-prolog

https://github.com/ekaf/wordnet-prolog

*Wordnet-prolog* includes new versions of the _WNprolog_ databases,
generated by Eric Kafe, and bundled with a copy of the original
WNprolog-3.0 documentation (c) 2012 Princeton University.

_WNprolog-3.0BF_ is a bugfix release of _WNprolog-3.0_.
It fixes some known problems, including the transitive hyponym bug.

_WNprolog-3.1_ is a _Prolog_ version of _WordNet 3.1_.

The accompanying _wnprolog.pl_ file is a SWI-prolog program 
implementing some common WordNet use cases, and a few formal checks, 
like symmetry and transitive loop detection.

The _pl2csv_ script translates each Prolog database to
a comma-separated CSV text file, for convenient
inter-operation with other projects. This output
constitutes complete WordNet versions in the CSV format:

* _WNcsv-3.0BF_
* _WNcsv-3.1_
