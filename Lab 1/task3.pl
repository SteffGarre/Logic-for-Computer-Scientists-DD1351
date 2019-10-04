
%findlast([Rest],[],Rest).
%findlast([_|Rest],[_|X],LastLine):-
 % findlast(Rest,X,LastLine).



findLast([H], [], H).
findLast([H|T], [H|R], Last) :- findLast(T, R, Last).
