verify(Input) :-
	see(Input), read(T), read(L), read(S), read(F), seen,
	check(T, L, S, [], F).

check(_, L, S, [], X) :-
	member([S,Z],L), 
	member(X, Z).

check(_, L, S, [], neg(X)) :-
	member([S,Z],L), 
	\+ member(X, Z).

check(T, L, S, [], and(F,G)) :-
	check(T, L, S, [], F),
	check(T, L, S, [], G).

check(T, L, S, [], or(F,G)) :- 
	check(T, L, S, [], F);
	check(T, L, S, [], G).

check(T, L, S, [], ax(F)) :-
	member([S, Z], T), 
	check_all(T, L, Z, [], F, F). 

check(T, L, S, visited, ag(F)):-
	member(S, visited).
check(T, L, S, visited, ag(F)) :-
	\+ member(S, visited),
	check(T, L, S, [], F), 
	member([S, Z], T), 
	check_all(T, L, Z, [S|visited], F, ag(F)). 

check(T, L, S, visited, af(F)):-
	\+ member(S, visited),
	check(T, L, S, [], F).

check(T, L, S, visited, af(F)) :- 
	\+ member(S, visited),
	member([S, Z], T), 
	check_all(T, L, Z, [S|visited], F, af(F)). 

check(T, L, S, visited, eg(F)):-
	member(S, visited).
check(T, L, S, visited, eg(F)) :-
	\+ member(S, visited),
	check(T, L, S, [], F),
	member([S, Z], T), 
	check_exist(T, L, Z, [S|visited], F, eg(F)). 

check(T, L, S, visited, ef(F)):-
	\+ member(S, visited),
	check(T, L, S, [], F). 
check(T, L, S, visited, ef(F)) :-
	\+ member(S, visited),
	member([S, Z], T), 
	check_exist(T, L, Z, [S|visited], F, ef(F)).

check(T, L, S, [], ex(F)) :-
	member([S, Z], T), 
	check_exist(T, L, Z, [], F, F).

check_all(_,_,[],_,_,_). 
check_all(T, L, [H|TAIL], visited, X, A) :-
	check(T, L, H, visited, A), 
	check_all(T, L, TAIL, visited, X, A). 

check_exist(_,_,[],_,_,_):- fail.
check_exist(T, L, [H|TAIL], visited, X, A) :-
	check(T, L, H, visited, A); 
	check_exist(T, L, TAIL, visited, X, A). 