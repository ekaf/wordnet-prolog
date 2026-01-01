/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/utils.pl

Interoperable utility predicates

Copyright 2017-25 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

:- include(timeit).

apply_call(P,L):-
  Term =.. [P|L],
  call(Term).

for_all(Cond, Action):-
  \+ (Cond, \+ Action).

% Minimal implementation of ordsets
ord_memberchk(E, [H|_]) :-
    E == H, !. % Membership check succeeds if found
ord_memberchk(E, [H|T]) :-
    E > H, % Continue searching (only if E > H, due to ordering)
    ord_memberchk(E, T).

ord_add_element([], E, [E]). % Add to empty set
ord_add_element([H|T], E, [E,H|T]) :-
    E < H, !. % Insert before element that is larger
ord_add_element([H|T], E, [H|NT]) :-
    E > H, % Continue checking
    ord_add_element(T, E, NT).
