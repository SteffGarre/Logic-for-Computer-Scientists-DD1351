%permute([], []).
%permute([H|T], S) :- 
%permute(T, P), 
%append(X, Y, P), 
%append(X, [H|Y], S).

%app([],X,X).
%app([X|L1],L2,[X|L3]):-
  %      app(L1,L2,L3).
select(X,[X|T],T).
select(X,[Y|T],[Y|R]) :- select(X,T,R).
