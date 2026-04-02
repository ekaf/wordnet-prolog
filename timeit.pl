/* -----------------------------------------------------------------------------
timeit.pl

Standard Prolog program to time predicate calls.

SPDX-FileCopyrightText: 2017-26 Eric Kafe <kafe@megadoc.net>
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

This module provides a portable implementation suitable for most Prolog systems:
- Measures execution time with `get_time/1` or `statistics/2`.
- Handles systems that report real-time in milliseconds (like GNU Prolog).
- Executes the Goal even if timing is unavailable.

Usage:
- `time_call(+Goal)` executes the Goal and prints the elapsed time.

------------------------------------------------------------------------------ */

current_time(T) :-
  % Get the current time in seconds. Use available mechanisms based on the 
  % Prolog system's support. If timing is unavailable, T is set to 'error'.
  ( 
  catch(get_time(T), _, fail)  % Preferred method
  -> true
  ; (
    statistics(real_time, [T0, _])  % Fallback to 'statistics/2'
    -> time_to_seconds(T0, T)
    ; T = error  % No timing support available
    )
  ).

time_to_seconds(T0, T) :-
  % Convert time to seconds if necessary (e.g., for GNU Prolog, which reports milliseconds).
  (
  pl_dialect(gprolog)  % Detects GNU Prolog
  -> T is T0 / 1000
  ; T = T0
  ).

time_call(Goal) :-
  % Measure the time taken to execute a given Goal once, and print the elapsed time.
  current_time(StartTime),
  call(Goal),  % Always execute the Goal
  (
  StartTime == error
  -> format('Timing unavailable for ~w.~n', [Goal])
  ; current_time(EndTime),
    Elapsed is EndTime - StartTime,
    format('~w executed in ~2f seconds.~n', [Goal, Elapsed])
  ).
