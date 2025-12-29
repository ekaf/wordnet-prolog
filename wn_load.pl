/* --------------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/wn_load.pl

SWI-prolog program to load all WordNet databases

Copyright 2025 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

-------------------------------------------------------------------- */

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim','vgp']).
lexrels(['ant','der','per','ppl','sa']).
lexinfo(['cls','fr','s','sk','syntax']).
seminfo(['g']).
morphinfo(['exc']).

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
allwn(L):-
  morphinfo(L),
  writef('\nMorphological Info: %w\n', [L]).

/* ------------------------------------------
Load WN
------------------------------------------ */

pred2arity(P,A,L):-
  current_predicate(P,Term),
  Term =.. [P|L],
  length(L,A).

loadpred(P):-
  swritef(F,'prolog/wn_%w.pl',[P]),
  consult(F),
  pred2arity(P,A,_),
  writef('Loaded %w (%w/%w)\n',[F,P,A]).

loadwn:-
  allwn(L),
  member(P,L),
  loadpred(P),
  false.
loadwn:-
  nl.

:-loadwn.
