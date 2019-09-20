
findlast([Rest],[],Rest).
findlast([_|Rest],[_|X],LastLine):-
  findlast(Rest,X,LastLine).

