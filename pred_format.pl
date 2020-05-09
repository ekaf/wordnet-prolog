/* 
# https://github.com/ekaf/wordnet-prolog/raw/master/pred_format.pl
(c) 2020 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/
*/

/* ------------------------------------------
Predicate arity and generic argument list
------------------------------------------ */

size2list(2,[_,_]).
size2list(3,[_,_,_]).
size2list(4,[_,_,_,_]).
size2list(5,[_,_,_,_,_]).
size2list(6,[_,_,_,_,_,_]).

pred2arity(P,A,L):-
  current_functor(P,A),
  size2list(A,L).
