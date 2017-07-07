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
Transitive hypernymy and hyponymy
--------------------------------------------------------------------*/

thyp(A,B):-
  hyp(A,B).
thyp(A,C):-
  hyp(A,B),
  thyp(B,C),
% Prevent transitive loops, like in WordNet 3.0:
 (A=C -> (writef('Transitive loop: %w %w %w\n', [A,B,C]),!,false); true).

/* ------------------------------------------
Word relations
------------------------- */

wordrel(R,A,B):-
% R is a relation between synsets
  s(I,_,A,_,_,_),
  apply(R,[I,J]),
  s(J,_,B,_,_,_).

relset(R,A,L):-
% Find all related words
  setof(B, wordrel(R,A,B), L),
  writef('%w %w : ', [A,R]),
  print(L),
  nl.

irelset(R,A,L):-
% Inverse relation
  setof(B, wordrel(R,B,A), L),
  writef('%w inverse %w : ', [A,R]),
  print(L),
  nl.

irel(R,W):-
% Apply relation in both directions
  (relset(R,W,L1),!; true), 
  (irelset(R,W,L2),!; true),
% If both sets are identical, the relation is symmetric
  (L1==L2 -> writef('Both sets are identical, so "%w %w X" is symmetric\n', [W,R]); true).

synset(W):-
% Synonyms
  relset(=,W).

/* ------------------------------------------
Word query
---------------------- */

qword(W):-
% Synonymy is symmetric
  irel(=,W),
  irel(thyp,W),
  semrels(L),
  member(R,L),
  irel(R,W),
  false.
qword(_).

/* ------------------------------------------
TEST 
--------------- */

test:-
  member(W,['car','tree','house','check','line','ukulele','London','Shakespeare']),
  qword(W),
  nl,
  false.
test.

:-test.
