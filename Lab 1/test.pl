permute([], []).
permute([H|T], S) :- 
permute(T, P), 
append(X, Y, P), 
append(X, [H|Y], S).