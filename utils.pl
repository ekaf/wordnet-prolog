/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/utils.pl

Interoperable utility predicates

Copyright 2017-25 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

:- include(timeit).

apply_call(P,L):-
  Term =..[P|L],
  call(Term).
