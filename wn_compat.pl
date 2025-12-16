/* 
https://github.com/ekaf/wordnet-prolog/raw/master/wn_compat.pl
(c) 2017-20 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

Prolog system-dependent features
*/


% provisional since scryer prolog does not provide the dialect flag nor if/1 directive

:- if(current_prolog_flag(dialect, scryer)).

:- use_module(library(format)).
:- use_module(library(lists)).

:-endif.



:- if(\+predicate_property(list_to_set(_,_),_)).

list_to_set(Ls0, Ls) :-
  sort(Ls0, Ls).

:- endif.


:- if(\+predicate_property(apply(_,_),_)).

apply(P, L) :-
  G =.. [P|L],
  call(G).

:- endif.
