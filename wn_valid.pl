/* 
# https://github.com/ekaf/wordnet-prolog/raw/master/wn_valid.pl
(c) 2020 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program testing for some potential issues in WordNet:

- check_keys: ambiguous sense keys, pointing to more than one synset
- symcheck: missing symmetry in the symmetric relations
- antisymcheck: direct loops in the antisymmetric relations
- hypself: self-hyponymous word forms
- check_duplicates: find duplicate clauses
*/

:-consult('db_version.pl').

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim','vgp']).
lexrels(['ant','der','per','ppl','sa']).
lexinfo(['cls','fr','s','sk','syntax']).
seminfo(['g']).

symrels(['sim','ant','der','vgp']).
antisymrels(['hyp','ins','mm','mp','ms','cls']).

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


/* ------------------------------------------
Ambiguous sense keys
------------------------------------------ */

multikey(K):-
  sk(I,_,K),
  sk(J,_,K),
  I\=J.

check_keys:-
  writeln('Searching for ambiguous sense keys'),
  findall(X, multikey(X), L),
  list_to_set(L,S),
  member(K,S),
  writef("Ambiguous key: %w\n",[K]),
  findall(I, sk(I,_,K), IL),
  list_to_set(IL,IS),
  member(I,IS),
  g(I,G),
  writef("    ->%w (%w)\n",[I,G]),
  false.
check_keys:-
  writeln('OK'),
  nl.

/* ------------------------------------------
Symmetry Test
------------------------------------------ */

symrel(2,R):-
  apply(R,[A,B]),
  (apply(R,[B,A]) -> true; writef('Missing %w(%w,%w)\n',[R,B,A])),
  false.
symrel(4,R):-
  apply(R,[A,B,C,D]),
  sk(A,B,K1),
  (apply(R,[C,D,A,B]) -> true; (sk(C,D,K2), writef('Missing %w from %w to %w\n',[R,K2,K1]))),
  false.
symrel(_,_):-
  writeln('OK').

symcheck:-
  symrels(L),
  member(R,L),
  swritef(F,'wn_%w.pl',[R]),
  writef('Checking symmetry in %w relation (%w):\n',[R,F]),
  current_functor(R,N),
  symrel(N,R),
  false.
symcheck:-
  nl.

/* ------------------------------------------
Antisymmetry test:
------------------------------------------ */

antisymrel(cls):-
  cls(A,AN,B,BN,T),
  cls(B,BN,A,AN,T),
  g(A,G1),
  g(B,G2),
  writef('Looping cls-%w:\n  from %w-%w (%w)\n    to %w-%w (%w)\n',[T,A,AN,G1,B,BN,G2]),
  false.
antisymrel(R):-
  R\=cls,
  apply(R,[A,B]),
  apply(R,[B,A]),
  g(A,G1),
  g(B,G2),
  writef('Looping %w:\n  from %w (%w)\n    to %w (%w)\n',[R,A,G1,B,G2]),
  false.
antisymrel(_):-
  writeln('OK').

antisymcheck:-
  antisymrels(L),
  member(R,L),
  swritef(F,'wn_%w.pl',[R]),
  writef('Checking antisymmetry in %w relation (%w):\n',[R,F]),
  antisymrel(R),
  false.
antisymcheck:-
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
  g(A,G1),
  g(B,G2),
  writef('"%w" hyp:\n  from %w-%w (%w)\n    to %w-%w (%w)\n',[W,A,N1,G1,B,N2,G2]),
  false.
hypself:-
  writeln('OK'),
  nl.

/* ------------------------------------------
Find Duplicates
------------------------------------------ */

size2list(2,[_,_]).
size2list(3,[_,_,_]).
size2list(4,[_,_,_,_]).
size2list(5,[_,_,_,_,_]).
size2list(6,[_,_,_,_,_,_]).

pred2arity(P,A,L):-
  current_functor(P,A),
  size2list(A,L).

:-dynamic duplicate/3.

outdups(N,P):-
  writef('Found %w duplicate %w:\n',[N,P]),
  listing(duplicate),
  retractall(duplicate(_,_,_)).

check_dup(P,L):-
  apply(P,L),
  findall((P,L), apply(P,L), PL),
  length(PL,N),
  (N>1 -> (duplicate(N,P,L)->true; assert(duplicate(N,P,L))); true),
  false.
check_dup(P,_):-
  findall((A,B,C),duplicate(A,B,C),L),
  length(L,N),
  (N>0 -> outdups(N,P); writeln('OK')).

check_duplicates:-
  allwn(LR),
  member(P,LR),
  pred2arity(P,A,L),
  writef('Checking duplicates in %w/%w\n',[P,A]),
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
  antisymcheck,
  check_duplicates,
%  hypself,
  told.
:-valid.
