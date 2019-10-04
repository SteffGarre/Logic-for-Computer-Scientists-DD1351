%permute([], []).
%permute([H|T], S) :- 
%permute(T, P), 
%append(X, Y, P), 
%append(X, [H|Y], S).

app([],L,L).
app([H|T],L,[H|R]) :- app(T,L,R).

%select(X,[X|T],T).
%select(X,[Y|T],[Y|R]) :- select(X,T,R).
