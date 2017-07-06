% SWI-prolog program by Eric Kafe

:-consult('wn_s.pl').

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim']).

loadrels:-
  semrels(L),
  member(R,L),
  swritef(F,'wn_%w.pl',[R]),
  writef('Consulting %w relation: %w\n',[R,F]),
  consult(F),
  fail.
loadrels.

:-loadrels.

/* -------------------------------------------------------------
Transitive hypernymy and hyponymy (need to increase stack size)
---------------------------------

hyp(A,C):-
  hyp(A,B),
  hyp(B,C).
*/

/* ------------------------------------------
Word relations
------------------------- */

wordrel(R,A,B):-
% R is a relation between synsets
  s(I,_,A,_,_,_),
  apply(R,[I,J]),
  s(J,_,B,_,_,_).

relset(R,A):-
% Find all related words
  setof(B, wordrel(R,A,B), L),
  writef('%w %w: ', [A,R]),
  print(L),
  nl.

irelset(R,A):-
% Inverse relation
  setof(B, wordrel(R,B,A), L),
  writef('%w inverse %w: ', [A,R]),
  print(L),
  nl.

irel(R,W):-
% Apply relation in both directions
  relset(R,W),
  irelset(R,W).

synset(W):-
% Synonyms
  relset(=,W).

/* ------------------------------------------
Word query
---------------------- */

qword(W):-
  synset(W),
  semrels(L),
  member(R,L),
  irel(R,W),
  fail.
qword(_).

/* ------------------------------------------
TEST 
--------------- */

test:-
  member(W,['car','tree','guitar','Lennon','London','Shakespeare']),
  qword(W),
  fail.
test.

:-test.
