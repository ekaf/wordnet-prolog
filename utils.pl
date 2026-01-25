/* -----------------------------------------------------------------
utils.pl

Interoperable utility predicates

SPDX-FileCopyrightText: 2017-26 Eric Kafe <kafe@megadoc.net>
SPDX-License-Identifier: Apache-2.0
Licensed under the Apache License, Version 2.0
----------------------------------------------------------------- */

:- include(timeit).
:- include(isotell).

% ------------------------------------------------------

dispatch_call(1, P, [A1])                 :- call(P, A1).
dispatch_call(2, P, [A1, A2])             :- call(P, A1, A2).
dispatch_call(3, P, [A1, A2, A3])         :- call(P, A1, A2, A3).
dispatch_call(4, P, [A1, A2, A3, A4])     :- call(P, A1, A2, A3, A4).
dispatch_call(5, P, [A1, A2, A3, A4, A5]) :- call(P, A1, A2, A3, A4, A5).
dispatch_call(6, P, [A1, A2, A3, A4, A5, A6]) :- call(P, A1, A2, A3, A4, A5, A6).

% ------------------------------------------------------

