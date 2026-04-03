/* -----------------------------------------------------------------
wn_valid.pl

Tests for a few potential Wordnet database bugs

SPDX-FileCopyrightText: 2017-26 Eric Kafe <kafe@megadoc.net>
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0


These problems sometimes occurred in past Wordnet versions,
but usually don't happen anymore:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- asymcheck: direct loops in the asymmetric relations
- wordless: empty synsets
- check_duplicates: find duplicate clauses

Additionally, the optional 'hypself' test finds self-hyponyms

----------------------------------------------------------------- */

:- include(loader).

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
  % Build Sense Key Index as the inverse of sk/3,
  % for Prolog systems that only index the first argument:
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
  format('Ambiguous key: ~w~n',[K]),
  setof(I, ski(K,I), IS),
  member(I,IS),
  g(I,G),
  format('    ->~w (~w)~n',[I,G]),
  false.
check_keys:-
  retractall(ski(_,_)),
  ok.


/* ------------------------------------------
Symmetry Test
------------------------------------------ */

% Symmetric relations:
symrels(['sim', 'ant', 'der', 'vgp']).

symrel(2,R):-
  call(R,A,B),
  (call(R,B,A) -> true; format('Missing ~w(~w,~w)~n',[R,B,A])),
  false.
symrel(4,R):-
  call(R,A,B,C,D),
  sk(A,B,K1),
  (call(R,C,D,A,B) -> true; (sk(C,D,K2), format('Missing ~w from ~w to ~w~n',[R,K2,K1]))),
  false.
symrel(_,_):-
  ok.

symcheck:-
  ensure_pred(sk),
  symrels(L),
  format('Symmetric relations: ~w~n',[L]),
  member(R,L),
  ensure_pred(R),
  atom_concat('wn_',R,F),
  format('Checking symmetry in ~w relation (~w.pl):~n',[R,F]),
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
  format('Looping cls-~w:~n  from ~w-~w (~w)~n    to ~w-~w (~w)~n',[T,A,AN,G1,B,BN,G2]),
  false.
asymrel(R):-
  R\=cls,
  call(R,A,B),
  call(R,B,A),
  glosspair(A,B,G1,G2),
  format('Looping ~w:~n  from ~w (~w)~n    to ~w (~w)~n',[R,A,G1,B,G2]),
  false.
asymrel(_):-
  ok.

asymcheck:-
  ensure_pred(g),
  asymrels(L),
  format('Asymmetric relations: ~w~n',[L]),
  member(R,L),
  ensure_pred(R),
  atom_concat('wn_',R,F),
  format('Checking asymmetry in ~w relation (~w.pl):~n',[R,F]),
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
  format('"~w" hyp:~n  from ~w-~w (~w)~n    to ~w-~w (~w)~n',[W,A,N1,G1,B,N2,G2]),
  false.
hypself:-
  ok,
  nl.


/* ------------------------------------------
Empty (i.e. wordless) synsets
------------------------------------------ */

wordless:-
  nl, write('Empty (i.e. wordless) synsets:'), nl,
 g(A,G),
 ( 
   s(A,_,_,_,_,_)
   -> true
   ;  format('~w: ~w~n',[A,G])
 ),
 false.
wordless:-
  ok.


/* ------------------------------------------
Find Duplicates
------------------------------------------ */

:- dynamic(duplicate/3).

outdups(N,P):-
  format('Found ~w duplicate ~w:~n',[N,P]),
  listing(duplicate),
  retractall(duplicate(_,_,_)).

check_dup(P):-
  current_predicate(P/A),
  format('Checking duplicates in ~w/~w~n',[P,A]),
  dispatch_call(A,P,L),
  findall((P,L), dispatch_call(A,P,L), PL),
  length(PL,N),
  (N>1, \+ duplicate(N,P,L) -> assertz(duplicate(N,P,L))),
  false.
check_dup(P):-
  findall((A,B,C),duplicate(A,B,C),L),
  length(L,N),
  (N>0 -> outdups(N,P); ok).

check_duplicates:-
  allwn(LR),
  member(P,LR),
  ensure_pred(P),
  check_dup(P),
  false.
check_duplicates:-
  nl.

/* ------------------------------------------
WN Validation
------------------------------------------ */

wn_tests([check_keys, symcheck, asymcheck, wordless, check_duplicates]).

run_tests:-
  time_call(mk_ski),
  % time check_keys independently of mk_ski
  wn_tests(L),
  member(T,L),
  time_call(T),
  false.
run_tests.

validation:-
  safe_consult(wn_load),
  wn_version(WV),
  atom_concat('output/wn_valid.pl-Output-',WV,F),
  open(F, write, Out),
  set_output(Out),
  time_call(load_wn),
  run_tests,
%  hypself,
  close(Out).

:- initialization(validation).
