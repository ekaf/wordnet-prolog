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


semrels('Semantic Relations', ['at','cs','ent','hyp','ins','mm','mp','ms','sim']).
lexrels('Lexical Relations', ['ant','der','per','ppl','sa','vgp']).
lexinfo('Lexical Info', ['cls','fr','s','sk','syntax']).
seminfo('Semantic Info', ['g']).
morphinfo('Morphological Info', ['exc']).

wndata([semrels,lexrels,lexinfo,seminfo,morphinfo]).

% --------------------------------------------------------------------------------

type_info(Type,Rels):-
  Term=..[Type,Label,Rels],
  call(Term),
  format(`~n~w: ~w~n`, [Label,Rels]).

allwn(Rels):-
  wndata(Reltypes),
  member(Type, Reltypes),
  type_info(Type,Rels).

/* ------------------------------------------
Load WN
------------------------------------------ */

pred2term(P,A,Term):-
  current_predicate(P/A),
  functor(Term,P,A).

load_pred(P):-
  atom_concat('prolog/wn_',P,F),
%  time_call(consult(F)).
  consult(F).

ensure_pred(P):-
  ( current_predicate(P/A) 
    -> format('Already loaded prolog/wn_~w.pl (~w/~w)~n',[P,P,A])
     ; load_pred(P) ).

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

:- initialization(consult(utils)).
