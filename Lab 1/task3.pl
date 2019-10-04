findlast([H],[], H).
findlast([H|T],[H|Rest],LastLine):-
  findlast(T, Rest,LastLine).