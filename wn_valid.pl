/* 
# https://github.com/ekaf/wordnet-prolog/raw/master/wn_valid.pl
(c) 2020-24 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program testing for some potential issues in WordNet:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- asymcheck: direct loops in the asymmetric relations
- hypself: self-hyponymous word forms
- check_duplicates: find duplicate clauses
*/

:- include(wn_compat).
:- include(db_version).

ok:-
  write('OK'), nl.

glosspair(A,B,G1,G2):-
  g(A,G1),
  g(B,G2).

/* ------------------------------------------
Ambiguous sense keys
------------------------------------------ */

check_keys:-
  write('Searching for ambiguous sense keys'), nl,
  find_multikey(K, IS),
  format('Ambiguous key: ~w\n',[K]),
  member(I,IS),
  g(I,G),
  format('    ->~w (~w)\n',[I,G]),
  false.
check_keys:-
  ok,
  nl.

/* :- if(true) for the original implementation of check_keys/0 based on original multikey/1.
   It needs an indexing mechanism on the third argument of sk/3 to obtain good performance.
   SWI performs well thanks to its multi-argument indexing.
   Prolog systems only indexing the first argument perform poorly.

   Markus Triska proposed a solution based on term_expansion/2 to index sk/3.
   See https://github.com/mthom/scryer-prolog/issues/1681#issuecomment-1374852413
   We use this approach  (see file wn_term_expans.pl)
   
   :- if(false) for an alternative implementation of checkeys/0 based on a new multikey/2.
   Daniel Diaz proposed another solution based on findall/setof and keysort
   (which are generally efficiently implemented).
   See https://github.com/mthom/scryer-prolog/issues/1681#issuecomment-1602996049

   If keeping both, consider factorizing similar code of both implementations.
*/

:- if(true).	% Original implementation with term_expansion/2 for other systems than SWI

:- if(current_prolog_flag(dialect, gprolog)).
:- compiler_mode(embed_compile).
:- endif.

use_term_expansion. % this is tested in wn_load.pl

:- if(current_prolog_flag(dialect, gprolog)).
:- compiler_mode(default).
:- endif.

find_multikey(K, IS) :-
  findall(X, multikey(X), L),
  list_to_set(L,S),
  member(K,S),
  findall(I, sk(I,_,K), IL),
  list_to_set(IL,IS).

multikey(K):-
  sk(I,_,K),
  sk(J,_,K),
  I \== J.

:- else.	% Alternative implementation based on findall/setof and keysort

find_multikey(K, IL) :-
  findall(K-I, sk(I, _, K), L1),
  keysort(L1, L2),
  setof(I, member(K-I, L2), IL),
  length(IL, N),
  N > 1.  % ensure at least 2 different tuples I \== J

:- endif.

/* ------------------------------------------
Symmetry Test
------------------------------------------ */

symrels(['sim','ant','der','vgp']).

symrel(2,R):-
  call(R,A,B),
  (call(R,B,A) -> true; format('Missing ~w(~w,~w)\n',[R,B,A])),
  false.
symrel(4,R):-
  call(R,A,B,C,D),
  sk(A,B,K1),
  (call(R,C,D,A,B) -> true; (sk(C,D,K2), format('Missing ~w from ~w to ~w\n',[R,K2,K1]))),
  false.
symrel(_,_):-
  ok.

symcheck:-
  symrels(L),
  format('Symmetric relations: ~w\n',[L]),
  member(R,L),
  format('Checking symmetry in ~w relation (wn_~w.pl):\n',[R,R]),
  pred2arity(R,N),
  symrel(N,R),
  false.
symcheck:-
  nl.

/* ------------------------------------------
Asymmetry test:
------------------------------------------ */

asymrels(['hyp','ins','mm','mp','ms','cls']).

asymrel(cls):-
  cls(A,AN,B,BN,T),
  cls(B,BN,A,AN,T),
  glosspair(A,B,G1,G2),
  format('Looping cls-~w:\n  from ~w-~w (~w)\n    to ~w-~w (~w)\n',[T,A,AN,G1,B,BN,G2]),
  false.
asymrel(R):-
  R\=cls,
  call(R,A,B),
  call(R,B,A),
  glosspair(A,B,G1,G2),
  format('Looping ~w:\n  from ~w (~w)\n    to ~w (~w)\n',[R,A,G1,B,G2]),
  false.
asymrel(_):-
  ok.

asymcheck:-
  asymrels(L),
  format('Asymmetric relations: ~w\n',[L]),
  member(R,L),
  format('Checking asymmetry in ~w relation (wn_~w.pl):\n',[R,R]),
  asymrel(R),
  false.
asymcheck:-
  nl.

/* ------------------------------------------
Self-hyponymous words
------------------------------------------ */

hypself:-
  write('Hyponymy between different senses of the same word:'),
% Note: this is usually not a problem, but some senses could need merging
  nl,
  hyp(A,B),
  s(A,N1,W,_,_,_),
  s(B,N2,W,_,_,_),
  glosspair(A,B,G1,G2),
  format('"~w" hyp:\n  from ~w-~w (~w)\n    to ~w-~w (~w)\n',[W,A,N1,G1,B,N2,G2]),
  false.
hypself:-
  ok,
  nl.

/* ------------------------------------------
Find Duplicates
------------------------------------------ */


:- dynamic(duplicate/3).

outdups(N,P):-
  format('Found ~w duplicate ~w:\n',[N,P]),
  retract(duplicate(X,Y,Z)),
  format('duplicate(~w, ~w, ~w).~n', [X, Y, Z]),
  fail.
outdups(_,_).


check_dup(P,L):-
  apply(P,L),
  findall((P,L), apply(P,L), PL),
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
  pred2arity(P,A,L),
  format('Checking duplicates in ~w/~w\n',[P,A]),
  check_dup(P,L),
  false.
check_duplicates:-
  nl.

/* ------------------------------------------
WN Validation
------------------------------------------ */

valid:-
  wn_version(WV),
  atom_concat('output/wn_valid.pl-Output-',WV,F),
  tell(F),
  loadwn,
  check_keys,
  symcheck,
  asymcheck,
  check_duplicates,
%  hypself,
  told.

:- include(wn_load). % this include must occur after use_term_expansion definition

:- initialization(valid).

