
permute([],[]).
permute([H|T],Y):-
  permute(T,L),
  select(H,Y,L).