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

% Ensure output stack is initialized (useful if initialization/1 is not run,
% or if the dynamic facts were cleared).
ensure_iniout :-
  (   laststream(_)
  ->  true
  ;   iniout
  ).

% Safely open file and add to stack
tells(Filename) :-
  ensure_iniout,
  catch(open(Filename, write, Stream), _, fail),
  catch(set_output(Stream), _, (catch(close(Stream), _, true), fail)),
  % update stack
  (   catch(retract(laststream(N0)), _, fail)
  ->  true
  ;   % Shouldn't happen because ensure_iniout/0 ran, but be defensive
      N0 = 0
  ),
  N is N0 + 1,
  catch(assertz(laststream(N)), _, true),
  catch(assertz(openstreams(N, Stream)), _, true).

% Safely close top stream and restore previous
tolds :-
  ensure_iniout,
  (   catch(retract(laststream(N0)), _, fail)
  ->  true
  ;   N0 = 0
  ),
  (   N0 =< 0
  ->  % underflow: restore recorded default output if we have it
      catch(assertz(laststream(0)), _, true),
      (   openstreams(0, Default)
      ->  catch(set_output(Default), _, true)
      ;   true
      )
  ;   % normal pop
      (   retract(openstreams(N0, Stream))
      ->  catch(close(Stream), _, true)
      ;   true
      ),
      N is N0 - 1,
      catch(assertz(laststream(N)), _, true),
      (   openstreams(N, StreamPrev)
      ->  catch(set_output(StreamPrev), _, true)
      ;   true
      )
  ).

% Always reset to clean state on initialization
iniout :-
  catch(retractall(laststream(_)), _, true),
  catch(retractall(openstreams(_, _)), _, true),
  catch(assertz(laststream(0)), _, true),
  (   catch(current_output(Default), _, fail)
  ->  catch(assertz(openstreams(0, Default)), _, true)
  ;   true
  ).

:- initialization(iniout).
