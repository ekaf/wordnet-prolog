/* -----------------------------------------------------------------------------
isotell.pl

ISO-compatible replacements for tell/1 and told/0.

SPDX-FileCopyrightText: 2026 Eric Kafe <kafe@megadoc.net>
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

Provides tells/1 and tolds/0 with proper stack semantics.
Use these instead of tell/told for portable code across Prolog systems.
------------------------------------------------------------------------------ */

:- dynamic(openstreams/2).
:- dynamic(laststream/1).

% Safely open file and add to stack
tells(Filename):-
  (   open(Filename, write, Stream)
  ->  set_output(Stream),
      retract(laststream(N0)),
      N is N0+1,
      assertz(laststream(N)),
      assertz(openstreams(N, Stream))
  ;   fail
  ).

% Safely close top stream and restore previous
tolds:-
  retract(laststream(N0)),
  (   N0=<0 
  ->  assertz(laststream(0))
  ;   retract(openstreams(N0, Stream)),
      catch(close(Stream), _, true),
      N is N0-1,
      assertz(laststream(N)),
      openstreams(N, StreamPrev),
      set_output(StreamPrev)
  ).

% Always reset to clean state on initialization
iniout:-
  retractall(laststream(_)),
  retractall(openstreams(_, _)),
  assertz(laststream(0)),
  current_output(Default),
  assertz(openstreams(0, Default)).

:- initialization(iniout).
