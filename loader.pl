/* -----------------------------------------------------------------
loader.pl

Load files only once

SPDX-FileCopyrightText: 2017-26 Eric Kafe <kafe@megadoc.net>
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0
----------------------------------------------------------------- */


% 1. Declare the tracking predicate as dynamic globally
:- dynamic(already_loaded/1).

% 2. Define safe_consult/1 only once
iniloader:-
  current_predicate(safe_consult/1) -> true
  ; assertz((
    safe_consult(File) :-         % Replaces ensure_loaded/1 (ISO)
      (  already_loaded(File)
         ->  format('~N% Info: ~w already loaded. Skipping.~n', [File])
         ; ( 
             format('~N% Consulting: ~w ... ', [File]),
             catch(flush_output, _, true),
             consult(File),
             assertz(already_loaded(File)),
             format('Done.~n', [])
           )
      )
    )).

:- initialization(iniloader).
