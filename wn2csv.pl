/* -----------------------------------------------------------------
wn2csv.pl

Convert all WordNet databases to comma-separated CSV files

SPDX-FileCopyrightText: 2017-26 Eric Kafe <kafe@megadoc.net>
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

spdx:-
  wn_version(V),
  format('# WordNet-Version: ~w~n', [V]),
  atom_chars(V, [H,_,N|_]),
  write('# SPDX-License-Identifier: WordNet'),
  ( H=='O' -> write(' AND CC-BY-4.0'); true ), nl,
  write('# SPDX-FileCopyrightText: '),
  ( N=='0' -> write('2006'); write('2011') ),
  write(' Princeton University'), nl,
  ( H=='O' -> write('# SPDX-FileCopyrightText: 2025 Open English Wordnet Community'), nl; true ),
  write('# -----------------------------------------------------------'), nl.

pred2file(P):-
  atom_concat('csv/wn_',P,C1),
  atom_concat(C1,'.csv',C),
  format('Writing ~w~n',[C]),
  tells(C),
  spdx.

out2csv(P):-
  ensure_pred(P),
  current_predicate(P/A),
  pred2file(P),
  dispatch_call(A,P,L),
  args2csv(L,P,1),
  false.
out2csv(_):-
  tolds.

convert_wn:-
  allwn(L),
  member(P,L),
  out2csv(P),
  false.
convert_wn.

inicsv:-
  safe_consult(wn_load),
  time_call(load_wn), 
  % loaded all dbs first, to time the conversion independently of consulting:
  time_call(convert_wn).

:- initialization(inicsv).
