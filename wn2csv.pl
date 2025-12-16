/* 
# https://github.com/ekaf/wordnet-prolog/raw/master/wn2csv.pl
(c) 2020-24 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program to convert all WordNet databases to comma-separated CSV files
*/

:- include(wn_compat).
:- include(wn_load).

pred2file(P):-
  atom_concat('csv/wn_',P,C1),
  atom_concat(C1,'.csv',C),
  format('Writing  ~w\n',[C]),
  tell(C).

list2csv([],_).
list2csv([A|T],S):-
  format('~a~q',[S,A]),
  list2csv(T,',').

out2csv(P):-
  pred2arity(P,_,L),
  apply(P,L),
  list2csv(L,''), nl,
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

:- initialization(convert_wn).
