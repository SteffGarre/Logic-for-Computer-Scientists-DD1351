%permute([],[]).
%permute([H|T],Y):-
  %permute(T,L),
  %select(H,Y,L).

permute([], []).
permute(In, [X|R]) :-
    select(X, In, Rest),
    permute(Rest, R).