/* 
https://github.com/ekaf/wordnet-prolog/wnprolog.pl
(c) 2017 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program implementing some common WordNet use cases, 
and a few formal checks, like symmetry and transitive loop detection.
*/

:-consult('wn_s.pl').

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim']).

loadrels:-
  semrels(L),
  member(R,L),
  swritef(F,'wn_%w.pl',[R]),
  writef('Consulting %w relation: %w\n',[R,F]),
  consult(F),
  false.
loadrels:-
  nl.

:-loadrels.

/* ------------------------------------------------------------------
Synonyms have the same identifier: */

syn(A,A).

/* ------------------------------------------------------------------
Transitive hypernymy and hyponymy: */

thyp(A,B):-
  hyp(A,B).
thyp(A,C):-
  hyp(A,B),
  thyp(B,C),
% Prevent transitive loops (f. ex. in original WordNet 3.0):
 (A=C -> writef('Transitive loop: %w %w %w\n', [A,B,C]), !; true).

/* ------------------------------------------------------------------
Word relations
------------------------- */

wordrel(R,A,B):-
% R is a relation between synsets
  s(I,_,A,_,_,_),
  apply(R,[I,J]),
  s(J,_,B,_,_,_).

outset([],_,_).
outset([H|T],A,R):-
  writef('%w %w: ', [A,R]),
  print([H|T]),
  nl.

irel(R,W):-
% Apply relation in both directions
% 1) Find all related words
  findall(X, wordrel(R,W,X), L1),
  sort(L1,S1),
  outset(S1,W,R),
% 2) Inverse relation
  findall(Y, wordrel(R,Y,W), L2),
  swritef(Ri,'inverse %w',[R]),
  sort(L2,S2),
  outset(S2,W,Ri),
% Check symmetric R
  samesets(S1,S2,R,W).

samesets(S,S,R,W):-
% If both sets are identical and non-empty, the relation is symmetric
  dif(S,[]),
  !,
  writef('Both sets are identical, so %w(%w,X) is symmetric\n', [R,W]).
samesets(_,_,_,_).

/* ------------------------------------------
Word query
---------------------- */

qword(W):-
% Synonymy is symmetric
  irel(syn,W),
  irel(thyp,W),
  semrels(L),
  member(R,L),
  irel(R,W),
  false.
qword(_).

/* ------------------------------------------
Tests
--------------- */

test:-
  member(W,['car','tree','house','check','line','ukulele','London','Shakespeare']),
  qword(W),
  nl,
  false.
test.

:-test.
