verify(InputFileName) :- see(InputFileName),
                        read(Prems),
                        read(Goal),
                        read(Proof),
                        seen,
                        valid_proof(Prems, Goal, Proof).

/*First check if goal is equal to last row of proof
The proof consists of lines, seperated by commas, so as an example:
[1, p, premise] meaning, line 1, variable p and the rules used is premise.
valid_proof([H|_],Goal,[P1|Prest]) :- check_goal(Goal,[P1|Prest]). */

nth(N,L,E) :- nth(1,N,L,E).
nth(N,N,[H|_],H).
nth(K,N,[_|T],H) :- K1 is K+1, nth(K1,N,T,H).


valid_proof([H|T], Goal, Proof) :- check_goal(Goal,Proof).

/*Assuming we have >0 number of lines for proof*/
check_goal(Goal, [H|_]) :- nth(2,H,X),Goal == X.
check_goal(Goal,[H|R]) :- check_goal(Goal,R).