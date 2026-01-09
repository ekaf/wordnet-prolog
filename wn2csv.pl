/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/wn2csv.pl

Convert all WordNet databases to comma-separated CSV files

Copyright 2017-26 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

:- include(loader).

escape_codes([], []).
escape_codes([H|T], O):-
  ( 
    H = 34    % repeat double quote (RFC 4180)
    -> O = [34,34|R]
    ;  O = [H|R]
  ),
  escape_codes(T, R).

escape_double_quotes(S, Escaped):-
  atom_codes(S, Codes),
  escape_codes(Codes, EscapedCodes),
  atom_codes(Escaped, EscapedCodes).

escape_index(exc, 2). % Word form
escape_index(exc, 3). % Lemma
escape_index(g, 2).   % Gloss
escape_index(s, 3).   % Lemma
escape_index(sk, 3).  % Sense key

handle_index(P, N, S):-
  escape_index(P,N)
  -> escape_double_quotes(S, S1),
     format('"~w"', [S1])  % double quote string
  ; format('~w', [S]).

args2csv([H|T], P, N) :-
  handle_index(P, N, H),
  (
    T \= [] 
   -> write(','), 
      N1 is N+1, 
      args2csv(T, P, N1)
   ; write('\r\n')  % The CSV standard requires CRLF
  ).

%---------------------------------------------------------

pred2file(P):-
  atom_concat('csv/wn_',P,C1),
  atom_concat(C1,'.csv',C),
  format('Writing ~w~n',[C]),
  tell(C).

out2csv(P):-
  pred2file(P),
  current_predicate(P/A),
  dispatch_call(A,P,L),
  args2csv(L,P,1),
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
