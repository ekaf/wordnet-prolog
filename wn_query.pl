/* 
https://github.com/ekaf/wordnet-prolog/raw/master/wn_query.pl
(c) 2017-20 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog program implementing some common WordNet use cases, 
and a few formal checks, like symmetry and transitive loop detection.
*/

:- include(wn_compat).
:- include(db_version). 
:- include('prolog/wn_s.pl').

semrels(['at','cs','ent','hyp','ins','mm','mp','ms','sim']).

loadrels:-
  semrels(L),
  member(R,L),
  atom_concat('prolog/wn_',R,F),
  format('Consulting ~w relation: ~w\n',[R,F]),
  catch(consult(F), Err, format('ERROR: ~w\n', [Err])),
  false.
loadrels:-
  nl.


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
 (A=C, !, format('Transitive loop: ~w ~w ~w\n', [A,B,C]); true).

/* ------------------------------------------------------------------
Word relations
------------------------- */

wordrel(R,A,B):-
% R is a relation between synsets, A and B are words
  s(I,_,A,_,_,_),
  call(R,I,J),
  s(J,_,B,_,_,_).

out2set([],_,_,[]).
out2set([H|T],W,R,S):-
  sort([H|T],S),
  outset(S,'',O),
  format('~w ~w: [~w]\n',[W,R,O]).

outset([H],A,B):-
  atom_concat(A,H,B).
outset([H|T],A,C):-
  atom_concat(A,H,B0),
  atom_concat(B0, ',', B),
  outset(T,B,C). % format('outset(~q,~q-> ~q)\n',[A,[H|T],C]).

sameset([H|T],[H|T]).

irel(R,W):-
% Apply relation in both directions
% 1) Find all related words
  findall(X, wordrel(R,W,X), L1),
  out2set(L1,W,R,S1),
% 2) Inverse relation
  findall(Y, wordrel(R,Y,W), L2),
  atom_concat('inverse ', R, Ri),
  out2set(L2,W,Ri,S2),
% 3) Check if R is symmetric
% If both sets are identical and non-empty, the relation is symmetric w.r.t. the query word:
  (sameset(S1,S2) -> format('Both sets are identical, so ~w(~w,X) is symmetric\n', [R,W]); true).

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
  loadrels,
  wn_version(WV),
  atom_concat('output/wn_query.pl-Output-',WV,F),
  tell(F),
  member(W,['car','tree','house','check','line','London']),
  qword(W),
  nl,
  false.
go:-
  told.

:- initialization(go).
