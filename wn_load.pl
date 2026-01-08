/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/wn_load.pl

Prolog program to load the WordNet databases.

Copyright 2017-26 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0


Use load_wn/0 to load everything, load_pred/1 (or rather ensure_pred/1) to
load a single relation, load_type/1, to load selected groups of relations,
f. ex. semantic (semrels) or lexical (lexrels).

----------------------------------------------------------------- */

:- include(db_version).
:- include(utils).

semrels('Semantic Relations', ['at','cs','ent','hyp','ins','mm','mp','ms','sim']).
lexrels('Lexical Relations', ['ant','der','per','ppl','sa','vgp']).
lexinfo('Lexical Info', ['cls','fr','s','sk','syntax']).
seminfo('Semantic Info', ['g']).
morphinfo('Morphological Info', ['exc']).

wndata([semrels,lexrels,lexinfo,seminfo,morphinfo]).

% --------------------------------------------------------------------------------

type_info(Type,Rels):-
  call(Type,Label,Rels),
  format('~n~w: ~w~n', [Label,Rels]).

allwn(Rels):-
  wndata(Reltypes),
  member(Type, Reltypes),
  type_info(Type,Rels).

/* ------------------------------------------
Load WN
------------------------------------------ */

ensure_pred(P):-
  atom_concat('prolog/wn_',P,F),
  format('Loading ~w~n',[F]),
  safe_consult(F).
%  time_call(safe_consult(F)).

load_type(Type):-
  type_info(Type,Rels),
  member(P,Rels),
  ensure_pred(P),
  false.
load_type(_).

load_wn:-
  allwn(L),
  member(P,L),
  ensure_pred(P),
  false.
load_wn:-
  nl.
