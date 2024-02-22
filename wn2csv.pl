/* 
# https://github.com/ekaf/wordnet-prolog/raw/master/wn2csv.pl
(c) 2020-24 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program to convert all WordNet databases to comma-separated CSV files
*/

:-consult('wn_load.pl').

pred2file(P):-
  atom_concat('csv/wn_',P,C1),
  atom_concat(C1,'.csv',C),
  writef('Writing  %w\n',[C]),
  tell(C).

list2csv([A],S0,S2):-
  swritef(S2,'%w%q',[S0,A]).
list2csv([A,B|T],S0,S2):-
  swritef(S1,'%w%q,',[S0,A]),
  list2csv([B|T],S1,S2).

out2csv(P):-
  pred2arity(P,_,L),
  apply(P,L),
  list2csv(L,'',S),
  writeln(S),
  false.
out2csv(_):-
  told.

convert_wn:-
  allwn(L),
  member(P,L),
  pred2file(P),
  out2csv(P),
  false.
convert_wn:-
  nl.

:-convert_wn.
