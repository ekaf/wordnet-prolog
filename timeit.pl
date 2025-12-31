/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/timeit.pl

Standard Prolog program to time predicate calls.

Copyright 2017-25 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

time2secs(T0, T):-
  current_prolog_flag(version_data, V),
  V=..[Sys|_],
  (
    % gprolog reports T0 in milliseconds
    Sys = gprolog -> T is T0/1000
    ;
    T = T0
  ).

current_time(T):-
  % Get the current time in seconds
  predicate_property(get_time(_), _) -> get_time(T) ;
  (
    statistics(real_time, [T0,_]) -> time2secs(T0,T)
    ;
    T = -1
  ).

time_call(Call):-
  current_time(T1),
  call(Call),
  (
    T1 = -1 -> format(`~w~n`, [Call])
    ;
    current_time(T2),
    Dif is T2 - T1,
    format(`~w in ~2f sec.~n`, [Call, Dif])
  ).
