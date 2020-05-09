/* 
https://github.com/ekaf/wordnet-prolog/raw/master/wn_query.pl
(c) 2017-20 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program implementing some common WordNet use cases, 
and a few formal checks, like symmetry and transitive loop detection.
*/

:-consult('db_version.pl').
:-consult('prolog/wn_s.pl').

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim']).

loadrels:-
  semrels(L),
  member(R,L),
  swritef(F,'prolog/wn_%w.pl',[R]),
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
 (A=C, !, writef('Transitive loop: %w %w %w\n', [A,B,C]); true).

/* ------------------------------------------------------------------
Word relations
------------------------- */

wordrel(R,A,B):-
% R is a relation between synsets, A and B are words
  s(I,_,A,_,_,_),
  apply(R,[I,J]),
  s(J,_,B,_,_,_).

out2set([],_,_,[]).
out2set([H|T],W,R,S):-
  sort([H|T],S),
  outset(S,'',O),
  writef('%w %w: [%w]\n',[W,R,O]).

outset([H],A,B):-
  swritef(B,'%w%w', [A,H]).
outset([H|T],A,C):-
  swritef(B,'%w%w,', [A,H]),
  outset(T,B,C).

sameset([H|T],[H|T]).

irel(R,W):-
% Apply relation in both directions
% 1) Find all related words
  findall(X, wordrel(R,W,X), L1),
  out2set(L1,W,R,S1),
% 2) Inverse relation
  findall(Y, wordrel(R,Y,W), L2),
  swritef(Ri,'inverse %w',[R]),
  out2set(L2,W,Ri,S2),
% 3) Check if R is symmetric
% If both sets are identical and non-empty, the relation is symmetric w.r.t. the query word:
  (sameset(S1,S2) -> writef('Both sets are identical, so %w(%w,X) is symmetric\n', [R,W]); true).

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
Test some word queries
------------------------------------------ */

go:-
  wn_version(WV),
  atom_concat('output/wn_query.pl-Output-',WV,F),
  tell(F),
  member(W,['car','tree','house','check','line','London']),
  qword(W),
  nl,
  false.
go:-
  told.
:-go.
