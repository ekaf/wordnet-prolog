/* 
# https://github.com/ekaf/wordnet-prolog/raw/master/wn_valid.pl
(c) 2020-24 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

Definiton of term_expansion/2 to speed up wn_valid.pl
*/

/*
See comment in wn_valid.pl.

This term_expansion tenchnique has been proposed by Markus Triska Scryer Prolog.
See https://github.com/mthom/scryer-prolog/issues/1681#issuecomment-1374852413 %
and https://github.com/mthom/scryer-prolog/issues/1681#issuecomment-1374853910.

It also works for other prolog systems only indexing predicates on the
first-argument (it is adapted for gprolog too).
*/

:- discontiguous(sk_1/3).
:- discontiguous(sk_3/3).

term_expansion(sk(X,Y,Z),
               [sk_1(X,Y,Z),
                sk_3(Z,X,Y)]).

sk(X, Y, Z) :-
        (   nonvar(X) ->
            sk_1(X, Y, Z)
        ;   nonvar(Z) ->
            sk_3(Z, X, Y)
        ;   sk_1(X, Y, Z)
        ).
