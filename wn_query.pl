/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/wn_query.pl

Some common WordNet use cases and formal checks

Copyright 2017-25 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

/* ------------------------------------------------------------------
Synonyms have the same identifier: */

syn(A,A).

/* ------------------------------------------------------------------
Transitive closure of Relation R, starting at Node A
Prevent transitive loops (f. ex. in original WordNet 3.0)
*/

closure(R, A, B, V):-
  apply_call(R, [A, B]),
  \+ member(B, V).
closure(R, A, B, V):-
  apply_call(R, [A, C]),
  \+ member(C, V),
  closure(R, C, B, [C|V]).

/* ------------------------------------------------------------------
Transitive closure of hypernymy, from Node A:
*/

thyp(A, B):-
  closure(hyp, A, B, [A]).

/* ------------------------------------------------------------------
Word relations
------------------------- */

wordrel(R,A,B):-
% R is a relation between synsets, A and B are words
  s(I,_,A,_,_,_),
  Term=..[R,I,J],
  call(Term),
  s(J,_,B,_,_,_).

out2set([],_,_,[]).
out2set([H|T],W,R,S):-
  sort([H|T],S),
  outset(S,'',O),
  format(`~w ~w: [~w]~n`,[W,R,O]).

outset([H],A,B):-
  atom_concat(A,H,B).
outset([H|T],A,C):-
  atom_concat(A,H,B),
  atom_concat(B,',',B2),
  outset(T,B2,C).

sameset([H|T],[H|T]).

irel(R,W):-
% Apply relation in both directions
% 1) Find all related words
  findall(X, wordrel(R,W,X), L1),
  out2set(L1,W,R,S1),
% 2) Inverse relation
  findall(Y, wordrel(R,Y,W), L2),
  atom_concat('inverse ',R,Ri),
  out2set(L2,W,Ri,S2),
% 3) Check if R is symmetric
% If both sets are identical and non-empty, the relation is symmetric w.r.t. the query word:
  (sameset(S1,S2) -> format(`Both sets are identical, so ~w(~w,X) is symmetric~n`, [R,W]); true).

/* ------------------------------------------
Word query
---------------------- */

qword(W):-
% Synonymy is symmetric
  irel(syn,W),
  irel(thyp,W),
  semrels(_,L),
  member(R,L),
  irel(R,W),
  false.
qword(_):-
  nl.

/* ------------------------------------------
Test some word queries
------------------------------------------ */

qini:-
  consult(db_version),
  wn_version(WV),
  atom_concat('output/wn_query.pl-Output-',WV,F),
  tell(F),
  consult(wn_load),
  ensure_pred(s),
  load_type(semrels),
  member(W,['car','tree','house','check','line','London']),
%  time_call(qword(W)),
  qword(W),
  false.
qini:-
  told.

:- initialization(qini).
