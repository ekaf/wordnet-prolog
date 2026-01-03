/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/wn2csv.pl

Convert all WordNet databases to comma-separated CSV files

Copyright 2017-26 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

:- include(loader).

pred2file(P):-
  atom_concat('csv/wn_',P,C1),
  atom_concat(C1,'.csv',C),
  format('Writing ~w~n',[C]),
  tell(C).

% escape_quotes(+Input, -Output)
escape_quotes(Input, Output) :-
    atom_chars(Input, InChars),
    escape_chars(InChars, OutChars),
    atom_chars(Output, OutChars).

escape_chars([], []).
escape_chars([H|T], O) :-
    (   H == '"'
    ->  O = ['"', '"'|R]
    ;   O = [H|R]
    ),
    escape_chars(T, R).

list2csv([A], P) :-
  ( P == g -> 
    (escape_quotes(A, A1), format('"~w"~n', [A1]))
  ; format('~w~n', [A])
  ).
list2csv([A, B|T], P) :-
  format('~w,', [A]),
  list2csv([B|T], P).

out2csv(P):-
  pred2file(P),
  current_predicate(P/A),
  dispatch_call(A,P,L),
  list2csv(L,P),
  false.
out2csv(_):-
  told.

convert_wn:-
  allwn(L),
  member(P,L),
  ensure_pred(P),
  out2csv(P),
  false.
convert_wn.

inicsv:-
  safe_consult(wn_load),
  load_wn, 
  % loaded all dbs first, to time the conversion independently of consulting:
  time_call(convert_wn).

:- initialization(inicsv).
