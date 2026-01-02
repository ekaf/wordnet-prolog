/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/utils.pl

Interoperable utility predicates

Copyright 2017-26 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */


apply_call(P,L):-
  Term =.. [P|L],
  call(Term).

for_all(Cond, Action):-
  \+ (Cond, \+ Action).

% Minimal implementation of ordsets
ord_memberchk(E, [H|T]) :-
    ( E == H  % Membership check succeeds if found
    ->  true
    ;   E @> H  % Continue searching (only if E > H)
    ->  ord_memberchk(E, T)
    ).

% ord_insert(+Set, +Element, -NewSet)
% Inserts Element into Set only if it is not already present, maintaining order.
ord_insert([], E, [E]).
ord_insert([H|T], E, NewSet) :-
    (   E == H
    ->  NewSet = [H|T]          % Already exists, don't duplicate
    ;   E @< H
    ->  NewSet = [E, H|T]       % Found insertion point
    ;   ord_insert(T, E, T1),   % Keep looking
        NewSet = [H|T1]
    ).

:- initialization(consult(timeit)).

