/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/utils.pl

Interoperable utility predicates

Copyright 2017-26 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

:- include(timeit).

dispatch_call(1, P, [A1])                 :- call(P, A1).
dispatch_call(2, P, [A1, A2])             :- call(P, A1, A2).
dispatch_call(3, P, [A1, A2, A3])         :- call(P, A1, A2, A3).
dispatch_call(4, P, [A1, A2, A3, A4])     :- call(P, A1, A2, A3, A4).
dispatch_call(5, P, [A1, A2, A3, A4, A5]) :- call(P, A1, A2, A3, A4, A5).
dispatch_call(6, P, [A1, A2, A3, A4, A5, A6]) :- call(P, A1, A2, A3, A4, A5, A6).

/* ----------------------------------------------------------------- */

def_forall:-
  current_predicate(ord_memberchk/2) -> true
  ;
  assertz((
    for_all(Cond, Action):-
      \+ (Cond, \+ Action)
    )).

def_inordset:-
  current_predicate(ord_memberchk/2) -> true
  ;
  % Minimal implementation of ordsets
  assertz((
    ord_memberchk(E, [H|T]) :-
      ( E == H  % Membership check succeeds if found
      ->  true
      ;   E @> H  % Continue searching (only if E > H)
      ->  ord_memberchk(E, T)
      )
  )).

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

iniutil:-
  def_forall,
  def_inordset.

:- initialization(iniutil).
