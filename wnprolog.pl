/* 
https://github.com/ekaf/wordnet-prolog/wnprolog.pl
(c) 2017 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program implementing common WordNet use cases, 
and intended later to also include more formal checks, 
like f. ex. transitive loop detection.
*/

:-consult('wn_s.pl').

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim']).

loadrels:-
  semrels(L),
  member(R,L),
  swritef(F,'wn_%w.pl',[R]),
  writef('Consulting %w relation: %w\n',[R,F]),
  consult(F),
  fail.
loadrels:-
  nl.

:-loadrels.

/* ------------------------------------------------------------------
Transitive hypernymy and hyponymy
Loops forever on the transitive bug in original WordNet 3.0 database
--------------------------------------------------------------------*/

thyp(A,B):-
  hyp(A,B).
thyp(A,C):-
  hyp(A,B),
  thyp(B,C).
% Evt. prevent the WordNet 3.0 transitive loop:
%  (A=C->(!,fail);true).

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
  irel(thyp,W),
  semrels(L),
  member(R,L),
  irel(R,W),
  fail.
qword(_).

/* ------------------------------------------
TEST 
--------------- */

test:-
  member(W,['car','tree','house','check']),
  qword(W),
  nl,
  fail.
test.

:-test.
