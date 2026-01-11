/* -----------------------------------------------------------------

https://github.com/ekaf/wordnet-prolog/raw/master/wn_query.pl

Some common WordNet use cases and formal checks

Copyright 2017-26 Eric Kafe
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0

----------------------------------------------------------------- */

:- include(loader).

% Synonyms have the same identifier: 

syn(A,A).

/* ------------------------------------------------------
Transitive closure of Relation R, starting at Node A
Prevent transitive loops (f. ex. in original WordNet 3.0)
-------------------------------------------------------- */

closure(Rel, Start, Visited, Result) :-
    % 1. Find an immediate neighbour
    call(Rel, Start, Next),
    % 2. Check for cycles using ordered membercheck of the Visited set
    \+ ord_memberchk(Next, Visited),
    % 3. Branch: Either this is a result, or we recurse deeper
    (   Result = Next
    ;   ord_insert(Visited, Next, NewVisited),
        closure(Rel, Next, NewVisited, Result)
    ).

/* ----------------------------------------------
Transitive closure of hypernymy, from Start node

thyp(?Start, ?Hyper)
Finds transitive hypernyms of Start.
*/

thyp(Start, Hyper) :-
    closure(hyp, Start, [], Hyper).

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
  format('~w ~w: [~w]~n',[W,R,O]).

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
  (sameset(S1,S2) -> format('Both sets are identical, so ~w(~w,X) is symmetric~n', [R,W]); true).

/* ------------------------------------------
Word query
---------------------- */

qword(W):-
% Synonymy is symmetric
  irel(syn,W),
  time_call(irel(thyp,W)),
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
  safe_consult(wn_load),
  wn_version(WV),
  atom_concat('output/wn_query.pl-Output-',WV,F),
  tell(F),
  ensure_pred(s),
  load_type(semrels),
  member(W,['car','tree','house','check','line','London']),
%  time_call(qword(W)),
  qword(W),
  false.
qini:-
  told.

:- initialization(qini).
