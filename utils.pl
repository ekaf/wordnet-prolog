/* -----------------------------------------------------------------
utils.pl

Interoperable utility predicates

SPDX-FileCopyrightText: 2017-26 Eric Kafe <kafe@megadoc.net>
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0
----------------------------------------------------------------- */

:- include(timeit).
:- include(isotell).

dispatch_call(1, P, [A1])                 :- call(P, A1).
dispatch_call(2, P, [A1, A2])             :- call(P, A1, A2).
dispatch_call(3, P, [A1, A2, A3])         :- call(P, A1, A2, A3).
dispatch_call(4, P, [A1, A2, A3, A4])     :- call(P, A1, A2, A3, A4).
dispatch_call(5, P, [A1, A2, A3, A4, A5]) :- call(P, A1, A2, A3, A4, A5).
dispatch_call(6, P, [A1, A2, A3, A4, A5, A6]) :- call(P, A1, A2, A3, A4, A5, A6).

/* ----------------------------------------------------------------- */
/* Portable “try” helpers */

% Succeeds even if Goal throws.
try(Goal) :-
  catch(Goal, _, true).

% Succeeds iff Goal succeeds; fails if Goal fails or throws.
try_ok(Goal) :-
  catch(Goal, _, fail).

safe_assertz(Clause) :-
  try(assertz(Clause)).

% Some systems provide abolish/1, others abolish/2; some restrict abolish.
safe_abolish(Name/Arity) :-
  try(abolish(Name/Arity)),
  try((Name/Arity = N/A, abolish(N, A))).

/* ----------------------------------------------------------------- */

def_forall :-
  (   try_ok(forall(true,true))
  ->  true
  ;   safe_assertz((
        forall(Cond, Action) :-
          \+ (Cond, \+ Action)
      ))
  ).

:- dynamic(dumm0y/1).
def_cleanup :-
  (   try_ok(retractall(dumm0y(_)))
  ->  safe_abolish(dumm0y/1)
  ;   safe_assertz((
        retractall(Goal) :-
          (   catch(retract(Goal), _, fail)
          ->  retractall(Goal)
          ;   true
          )
      ))
  ).

def_inordset :-
  (   try_ok(ord_memberchk(b,[a,b,c]))
  ->  true
  ;   % Minimal implementation of ordsets
      safe_assertz((
        ord_memberchk(E, [H|T]) :-
          ( E == H
          -> true
          ; E @> H
          -> ord_memberchk(E, T)
          )
      ))
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

iniutil :-
  def_forall,
  def_cleanup,
  def_inordset.

:- initialization(iniutil).
