findlast([H],[], H).
findlast([H|T],[H|Rest],E):-
  findlast(T, Rest, E).