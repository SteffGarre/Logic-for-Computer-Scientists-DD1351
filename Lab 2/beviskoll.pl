% 
verify(InputFileName) :- see(InputFileName),
read(Prems), read(Goal), read(Proof),
seen,
valid_proof(Prems, Goal, Proof).

valid_proof(Prems, Goal, Proof):-
  findlast(Proof,Rest,LastLine),
  valid_goal(Goal, LastLine),
  %reverse(Proof, Reversed),
  valid_proof2(Prems,Proof).

valid_proof2(Prems, []) :-
  write('yes\n').

valid_proof2(Prems, Proof) :-
  findlast(Proof,Rest,LastLine),
  find_box(Prems,Proof, LastLine),
  valid_proof2(Prems, Rest).

% bara välja denna om det är en lista av fler än en lista
find_box(Prems, Proof, [[L1,F1,_Rule]| [Box|Tail]]) :-
  findlast([[L1,F1,_Rule]| [Box|Tail]], Rest, LastLine),
  append([[L1,F1,_Rule]| [Box|Tail] ], Proof, Both),
  valid_line(Prems, Both, LastLine),
  find_box(Prems, Proof, Rest).

% Checking assumption
find_box(Prems, Proof, [[_LineNumber, _Formula, assumption]]):-
  write('assumption OK! \n').

 % bara välja om lista av tre element
find_box(Prems, Proof, [LineNumber, Formula, Rule]):-
  valid_line(Prems, Proof, [LineNumber, Formula, Rule]).

% Checking goal
valid_goal(Goal, [_LineNumber, Formula, _Rule]):-
  Formula == Goal,
  write('Goal OK! \n').

% Find the last line in proof
findlast([Rest],[],Rest).
findlast([FirstLine|Rest],[FirstLine|Rest2],LastLine):-
  findlast(Rest,Rest2,LastLine).

% Checking premises
valid_line(Prems, Proof, [_LineNumber, Formula, premise]) :-
  member(Formula, Prems),
  write('premise uppfyllt! \n ').

% And elimination 1
valid_line(_Prems , Proof,  [_LineNumber, Formula, andel1(Line)]) :-
  member([Line, and(Formula, _), _], Proof),
  write('andel1 uppfyllt! \n').

% And elimination 2
valid_line(_Prems , Proof, [_LineNumber, Formula, andel2(Line)]) :-
  member([Line, and(_, Formula), _], Proof),
  write('andel2 uppfyllt! \n').

 % Implication elimination
valid_line(_Prems , Proof, [_LineNumber, Formula, impel(Line, Line2)]) :-
  member([Line, Formula2, _], Proof),
  member([Line2, imp(Formula2,Formula), _], Proof),
  write('impel uppfyllt! \n').

% And introduction
valid_line(_Prems, Proof, [LineNumber, Formula, andint(Line1, Line2)]) :-
  member([Line1, Formula1, _], Proof),
  member([Line2, Formula2, _], Proof),
  member([LineNumber, and(Formula1, Formula2), _], Proof),
  write('andint uppfyllt! \n').

% Or introduction 1
valid_line(_Prems, Proof, [_LineNumber, Formula, orint1(Line)]) :-
  member([Line, or(Formula, _), _], Proof),
  write('orint1 uppfyllt! \n').

 % Or introduction 2
valid_line(_Prems, Proof, [_LineNumber, Formula, orint2(Line)]) :-
  member([Line, or(_, Formula), _], Proof),
  write('orint2 uppfyllt! \n').

% Contradiction eleminiation
valid_line(_Prems, Proof, [_LineNumber, _Formula, contel(Line)]) :-
  member([Line, cont, _], Proof),
  write('contel uppfyllt! \n').

% Negation eleminiation
valid_line(_Prems, Proof, [LineNumber, _Formula, negel(Line, Line2)]) :-
  member([Line, Formula2,_], Proof),
  member([Line2, neg(Formula2),_], Proof),
  member([LineNumber, cont, _], Proof),
  write('negel uppfyllt! \n').

% Double Negation eleminiation
valid_line(_Prems, Proof, [_LineNumber, Formula, negnegel(Line)]) :-
  member([Line, neg(neg(Formula)), _], Proof),
  write('negnegel uppfyllt! \n').

% copy
valid_line(_Prems, Proof, [LineNumber, _Formula, copy(Line)]) :-
  member([Line, Formula2 ,_], Proof),
  member([LineNumber, Formula2,_], Proof).

% MT
valid_line(_Prems , Proof, [LineNumber, _Formula, mt(Line, Line2)]) :-
  member([Line2, neg(Formula2), _], Proof),
  member([Line, imp(Formula1,Formula2), _], Proof),
  member([LineNumber, neg(Formula1), _], Proof),
  write('mt uppfyllt! \n').

 % Double Negation introduction
valid_line(_Prems , Proof, [LineNumber, Formula, negnegint(Line)]) :-
  member([Line, Formula2, _], Proof),
  member([LineNumber, neg(neg(Formula2)), _], Proof),
  write('negnegint uppfyllt! \n').

 % LEM
valid_line(_Prems , Proof, [LineNumber, Formula, lem]) :-
  member([LineNumber, or(_X,neg(_X)), _], Proof),
  write('lem uppfyllt! \n').

 % Implication introduction
valid_line(_Prems , Proof, [_LineNumber, Formula, impint(Line1, Line2)]) :-
  findlast(Proof,Rest,LastLine),
  findlast(Rest,R,[[L1,F1,_Rule]| Box ]),
  L1 == Line1,
  findlast(Box,R1,[L2,F2,_Rule2]),
  L2 == Line2,
  Formula == imp(F1, F2),
  write('impint uppfyllt! \n').

% Negation introduction
valid_line(_Prems , Proof, [LineNumber, Formula, negint(Line1, Line2)]) :-
  findlast(Proof,Rest,LastLine),
  findlast(Rest,R,[[Line1,F1,_Rule]| Box ]),
  %L1 == Line1,
  findlast(Box,R1,[Line2,cont,_Rule2]),
  %L2 == Line2,
  %F2 == cont,
  Formula == neg(F1),
  write('negint uppfyllt! \n').

  % PBC
valid_line(_Prems , Proof, [LineNumber, Formula, pbc(Line1, Line2)]) :-
  findlast(Proof,Rest,LastLine),
  findlast(Rest,R,[[L1,neg(F1),_Rule]| Box ]),
  L1 == Line1,
  findlast(Box,R1,[L2,F2,_Rule2]),
  L2 == Line2,
  F2 == cont,
  Formula == F1,
  write('pbc uppfyllt! \n').

  % Or eleminiation
valid_line(_Prems , Proof, [LineNumber, Formula, orel(Line1, Line2, Line3, Line4, Line5)]) :-
  member([[Line4, F1, _Rule]| ])
  findlast(Proof,Rest,LastLine),
  findlast(Rest,R4,[[L4, F4,_Rule4]| Box ]),
  L4 == Line4,
  findlast(Box,R5,[L5,F5,_Rule5]),
  L5 == Line5,
  F5 == Formula,
  nth1(Line2, Proof, [[L2, F2,_Rule2]| Box2 ]),
  L2 == Line2,
  findlast(Box2,R3,[L3,F3,_Rule3]),
  L3 == Line3,
  F3 == Formula,
  member([Line1, or(F2,F4), _], Proof),
  write('orel uppfyllt! \n').