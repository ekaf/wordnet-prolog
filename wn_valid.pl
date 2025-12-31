/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/wn_valid.pl

Tests for a few potential Wordnet database bugs

Copyright 2017-25 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

/*
These problems sometimes occurred in past Wordnet versions,
but usually don't happen anymore:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- asymcheck: direct loops in the asymmetric relations
- check_duplicates: find duplicate clauses

Additionally, the optional 'hypself' test finds the self-hyponymous word forms.
*/

ok:-
  write('OK'),
  nl, nl.

glosspair(A,B,G1,G2):-
  g(A,G1),
  g(B,G2).


/* ------------------------------------------
Ambiguous sense keys
------------------------------------------ */

:- dynamic(ski/2).

mk_ski:-
  % Make inverse of sk, for prologs that only index first arg
  forall(sk(I,_,K), assertz(ski(K,I))).

multikey(K):-
  ski(K,I),
  ski(K,J),
  I < J.

check_keys:-
  write('Searching for ambiguous sense keys'),
  nl,
  setof(X, multikey(X), KS),
  member(K,KS),
  format(`Ambiguous key: ~w~n`,[K]),
  setof(I, ski(K,I), IS),
  member(I,IS),
  g(I,G),
  format(`    ->~w (~w)~n`,[I,G]),
  false.
check_keys:-
  retractall(ski(_,_)),
  ok.


/* ------------------------------------------
Symmetry Test
------------------------------------------ */

% Symmetric relations:
symrels(['sim','ant','der','vgp']).

symrel(2,R):-
  apply_call(R,[A,B]),
  (apply_call(R,[B,A]) -> true; format(`Missing ~w(~w,~w)~n`,[R,B,A])),
  false.
symrel(4,R):-
  apply_call(R,[A,B,C,D]),
  sk(A,B,K1),
  (apply_call(R,[C,D,A,B]) -> true; (sk(C,D,K2), format(`Missing ~w from ~w to ~w~n`,[R,K2,K1]))),
  false.
symrel(_,_):-
  ok.

symcheck:-
  ensure_pred(sk),
  symrels(L),
  format(`Symmetric relations: ~w~n`,[L]),
  member(R,L),
  ensure_pred(R),
  atom_concat('wn_',R,F),
  format(`Checking symmetry in ~w relation (~w.pl):~n`,[R,F]),
  current_predicate(R/N),
  symrel(N,R),
  false.
symcheck:-
  nl.


/* ------------------------------------------
Asymmetry test:
------------------------------------------ */

% Asymmetric relations:
asymrels(['hyp','ins','mm','mp','ms','cls']).

asymrel(cls):-
  cls(A,AN,B,BN,T),
  cls(B,BN,A,AN,T),
  glosspair(A,B,G1,G2),
  format(`Looping cls-~w:~n  from ~w-~w (~w)~n    to ~w-~w (~w)~n`,[T,A,AN,G1,B,BN,G2]),
  false.
asymrel(R):-
  R\=cls,
  apply_call(R,[A,B]),
  apply_call(R,[B,A]),
  glosspair(A,B,G1,G2),
  format(`Looping ~w:~n  from ~w (~w)~n    to ~w (~w)`,[R,A,G1,B,G2]),
  false.
asymrel(_):-
  ok.

asymcheck:-
  ensure_pred(g),
  asymrels(L),
  format(`Asymmetric relations: ~w~n`,[L]),
  member(R,L),
  ensure_pred(R),
  atom_concat('wn_',R,F),
  format(`Checking asymmetry in ~w relation (~w.pl):~n`,[R,F]),
  asymrel(R),
  false.
asymcheck:-
  nl.


/* ---------------------------------------------------------------------
Self-hyponymous words
NB: this is usually not a problem, but some senses could need merging
---------------------------------------------------------------------- */

hypself:-
  ensure_pred(s),
  write('Hyponymy between different senses of the same word:'),
  nl,
  hyp(A,B),
  s(A,N1,W,_,_,_),
  s(B,N2,W,_,_,_),
  glosspair(A,B,G1,G2),
  format(`"~w" hyp:~n  from ~w-~w (~w)~n    to ~w-~w (~w)`,[W,A,N1,G1,B,N2,G2]),
  false.
hypself:-
  ok,
  nl.

/* ------------------------------------------
Find Duplicates
------------------------------------------ */


:- dynamic(duplicate/3).

outdups(N,P):-
  format(`Found ~w duplicate ~w:~n`,[N,P]),
  listing(duplicate),
  retractall(duplicate(_,_,_)).

check_dup(P,L):-
  apply_call(P,L),
  findall((P,L), apply_call(P,L), PL),
  length(PL,N),
  (N>1, \+ duplicate(N,P,L) -> assertz(duplicate(N,P,L))),
  false.
check_dup(P,_):-
  findall((A,B,C),duplicate(A,B,C),L),
  length(L,N),
  (N>0 -> outdups(N,P); ok).

check_duplicates:-
  allwn(LR),
  member(P,LR),
  ensure_pred(P), 
  pred2term(P,A,Term),
  format(`Checking duplicates in ~w/~w~n`,[P,A]),
  Term =.. [P|L],
  check_dup(P,L),
  false.
check_duplicates:-
  nl.

/* ------------------------------------------
WN Validation
------------------------------------------ */

wn_tests([check_keys, symcheck, asymcheck, check_duplicates]).

run_tests:-
  time_call(mk_ski),
  % time check_keys independently of mk_ski
  wn_tests(L),
  member(T,L),
  time_call(T),
  false.
run_tests.

validation:-
  consult(db_version),
  wn_version(WV),
  atom_concat('output/wn_valid.pl-Output-',WV,F),
  tell(F),
  consult(wn_load),
  load_wn,
  run_tests,
%  hypself,
  told.

:- initialization(validation).
