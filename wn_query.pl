/* -----------------------------------------------------------------
wn_query.pl

Some common WordNet use cases and formal checks

SPDX-FileCopyrightText: 2017-26 Eric Kafe <kafe@megadoc.net>
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0
----------------------------------------------------------------- */

:- include(loader).

% Synonyms have the same identifier: 

syn(A,A).

/* -------------------------------------------------------------------
Transitive closure of Relation R in linear time, from 'Start' synset.
Prevent transitive loops using dynamic visited/1
-------------------------------------------------------------------- */

:- dynamic(visited/1).

closure1(Rel, Start) :-
    call(Rel, Start, Next),  % Find an immediate neighbour
    \+ visited(Next),        % O(1) lookup to prevent loop
    assertz(visited(Next)),  % Store result
    closure1(Rel, Next),     % More results: recurse #Next times
    false.
closure1(_, _).

closure(Rel, Start, List) :-
    closure1(Rel, Start),
    findall(Next, visited(Next), List),
    retractall(visited(_)).

/* ------------------------------------------------
Transitive closure of hypernymy, from Start synset

thyp(?Start, ?Hyper)
Finds transitive hypernyms of Start.
*/

thyp(Start, Hyper) :-
    closure(hyp, Start, List),
    member(Hyper, List).

test_all_hyp:-
  % Comprehensive test for timing closure algorithm
  forall(g(Id,_), closure(hyp, Id, _)).

/*  ------------------------------------------------
Transitive closure of Rel, starting at Word
*/

ss_words(Id):-
  findall(W, s(Id,_,W,_,_,_), L),
  format('~w: ~w~n',[Id,L]).

word_closure(Rel, Word):-
  format('Transitive ~w of ~w:~n', [Rel, Word]),
  s(Id, _, Word, _, _, _),
  closure(Rel, Id, L),
  forall(member(M,L), ss_words(M)),
  write('OK'), nl.



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
  tells(F),
  time_call(ensure_pred(s)),
  time_call(load_type(semrels)),
  member(W,['car','tree','house','check','line','London']),
  % Note that 'London' is not a hyponym but an instance
  qword(W),
  false.
qini:-
  time_call(word_closure(hyp, 'rock hind')), % The deepest hyponym in WordNet
  time_call(ensure_pred(g)),
  time_call(test_all_hyp),
  tolds.

:- initialization(qini).
