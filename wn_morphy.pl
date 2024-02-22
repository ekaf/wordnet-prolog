/* ----------------------------------------------------------------------------- 
# https://github.com/ekaf/wordnet-prolog/raw/master/wn_morphy.pl
(c) 2020 Eric Kafe, CC BY 4.0, https://creativecommons.org/licenses/by/4.0/

SWI-prolog lemmatizer, similar to "morphy",
the morphological processor from WordNet.

-------------------------------------------------------------------------------*/

:-consult(prolog/wn_exc).
:-consult(prolog/wn_s).

% Since v. 7.0, swipl requires this flag for double quotes to produce bytelists:
:-set_prolog_flag(double_quotes,codes).

ending(n, "s", "").
ending(n, "ses", "s").
ending(n, "xes", "x").
ending(n, "zes", "z").
ending(n, "ches", "ch").
ending(n, "shes", "sh").
ending(n, "men", "man").
ending(n, "ies", "y").
ending(v, "s", "").
ending(v, "ies", "y").
ending(v, "es", "e").
ending(v, "es", "").
ending(v, "ed", "e").
ending(v, "ed", "").
ending(v, "ing", "e").
ending(v, "ing", "").
ending(a, "er", "").
ending(a, "est", "").
ending(a, "er", "e").
ending(a, "est", "e").
% Proposed addition to Princeton morphy:
ending(a, "ier", "y").
ending(a, "iest", "y").

morph(Pos,Form,Lemma):-
  exc(Pos,Form,Lemma).
morph(Pos,Form,Lemma):-
  atom_codes(Form,Fc),
  ending(Pos,Strip,Add),
  append(Root,Strip,Fc),
  append(Root,Add,Lc),
  atom_codes(Lemma,Lc).
morph(Pos,X,X):-
  member(Pos,[a,v,n,r]).

lemma_pos_in_wn(Lemma,Pos,Synset,WordNr):-
% Check that Lemma is in WordNet with the corresponding Pos tag, so for ex.
% the adjective "aerobic" is not the lemma of the noun "aerobics".
  s(Synset,WordNr,Lemma,Pos,_,_).

wordform2lemma(Form,Pos,Lemma,Synset,WordNr):-
  morph(Pos,Form,Lemma),
  lemma_pos_in_wn(Lemma,Pos,Synset,WordNr).

morphy(Wordform, Set):-
% Output the set of possible Lemmas:
  setof((Synset,WordNr,Lemma,Pos),
    wordform2lemma(Wordform,Pos,Lemma,Synset,WordNr),
    Set).

% Example usage:
%:-morphy(advertizing, S), writeln(S).
