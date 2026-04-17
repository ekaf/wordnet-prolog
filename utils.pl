/* -----------------------------------------------------------------
utils.pl

Interoperable utility predicates

SPDX-FileCopyrightText: 2017-26 Eric Kafe <kafe@megadoc.net>
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0
----------------------------------------------------------------- */

:- include(timeit).

:- dynamic(pl_dialect/1).
:- dynamic(pl_version/1).

store_dialect :-
  retractall(pl_dialect(_)),
  %  Retrieve the system name (Dialect)
  (   catch(current_prolog_flag(dialect, Dialect), _, fail)
  ->  true
  ;   Dialect = unknown
  ),
  assertz(pl_dialect(Dialect)),
  write('System: '), write(Dialect).

store_version :-
  retractall(pl_version(_)),
  % Retrieve the version (Check version_data first, fallback to version)
  (   catch(current_prolog_flag(version_data, Version), _, fail)
  ->  true
  ;   catch(current_prolog_flag(version, Version), _, fail)
  ->  true
  ;   Version = unknown
  ),
  assertz(pl_version(Version)),
  write(', Version: '), write(Version), nl.

store_pl :-
  store_dialect,
  store_version.

% ----------------------------------------------------------------------------------



dispatch_call(1, P, [A1])                 :- call(P, A1).
dispatch_call(2, P, [A1, A2])             :- call(P, A1, A2).
dispatch_call(3, P, [A1, A2, A3])         :- call(P, A1, A2, A3).
dispatch_call(4, P, [A1, A2, A3, A4])     :- call(P, A1, A2, A3, A4).
dispatch_call(5, P, [A1, A2, A3, A4, A5]) :- call(P, A1, A2, A3, A4, A5).
dispatch_call(6, P, [A1, A2, A3, A4, A5, A6]) :- call(P, A1, A2, A3, A4, A5, A6).

/* ----------------------------------------------------------------- */

:- if(\+ predicate_property(forall(_, _), _)).
forall(Cond, Action):-
    \+ (Cond, \+ Action).
:- endif.

:- if(\+ predicate_property(ord_memberchk(_, _),_ )).
  % Minimal implementation of ordsets
ord_memberchk(E, [H|T]) :-
    (   E == H		% Membership check succeeds if found
    ->  true
    ;   E @> H  % Continue searching (only if E > H)
    ->  ord_memberchk(E, T)
    ).
:- endif.

:- if(\+ predicate_property(ord_insert(_, _, _),_ )).
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
:- endif.
