/* 
# https://github.com/ekaf/wordnet-prolog/raw/master/wn_load.pl
(c) 2020 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program to load all WordNet databases
*/

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim','vgp']).
lexrels(['ant','der','per','ppl','sa']).
lexinfo(['cls','fr','s','sk','syntax']).
seminfo(['g']).

allwn(L):-
  semrels(L),
  writef('\nSemantic Relations: %w\n', [L]).
allwn(L):-
  lexrels(L),
  writef('\nLexical Relations: %w\n', [L]).
allwn(L):-
  lexinfo(L),
  writef('\nLexical Info: %w\n', [L]).
allwn(L):-
  seminfo(L),
  writef('\nSemantic Info: %w\n', [L]).

/* ------------------------------------------
Load WN
------------------------------------------ */

loadpred(P):-
  swritef(F,'prolog/wn_%w.pl',[P]),
  consult(F),
  current_functor(P,A),
  writef('Loaded %w (%w/%w)\n',[F,P,A]).

loadwn:-
  allwn(L),
  member(P,L),
  loadpred(P),
  false.
loadwn:-
  nl.

:-loadwn.
