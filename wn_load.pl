/* 
# https://github.com/ekaf/wordnet-prolog/raw/master/wn_load.pl
(c) 2020-24 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program to load all WordNet databases
*/

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim','vgp']).
lexrels(['ant','der','per','ppl','sa']).
lexinfo(['cls','fr','s','sk','syntax']).
seminfo(['g']).
morphinfo(['exc']).

allwn(L):-
  semrels(L),
  format('\nSemantic Relations: ~w\n', [L]).
allwn(L):-
  lexrels(L),
  format('\nLexical Relations: ~w\n', [L]).
allwn(L):-
  lexinfo(L),
  format('\nLexical Info: ~w\n', [L]).
allwn(L):-
  seminfo(L),
  format('\nSemantic Info: ~w\n', [L]).
allwn(L):-
  morphinfo(L),
  format('\nMorphological Info: ~w\n', [L]).

/* ------------------------------------------
Load WN
------------------------------------------ */

pred2arity(P,A):-
  current_predicate(P/A), !.	% should be deterministic !

pred2arity(P,A,L):-
  pred2arity(P,A),
  length(L,A).

loadpred(P):-
  atom_concat('prolog/wn_', P, F),
  loadfile(F),
  pred2arity(P,A,_),
  format('Loaded ~w.pl (~w/~w)\n',[F,P,A]).

loadwn:-
  allwn(L),
  member(P,L),
  loadpred(P),
  false.
loadwn:-
  nl.

:- if((current_predicate(use_term_expansion/0), current_prolog_flag(dialect, D), D \== swi)).
:- if(current_prolog_flag(dialect, gprolog)).

loadfile(F) :-
  decompose_file_name(F,_,wn_sk,_), !,
  consult(F, [include(wn_term_expans)]).

loadfile(F) :-
  consult(F).

:- else.

:- include(wn_term_expans).

loadfile(F) :-
  consult(F).

:- endif.

:- else.

loadfile(F) :-
  consult(F).

:- endif.

