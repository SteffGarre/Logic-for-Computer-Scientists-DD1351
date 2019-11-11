verify(InputFileName) :-
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof).
  
  %Updates the list which contains the checked proof
  addList(List1, Head, [Head|List1]).
  
  updateList([Head|List1], Head).
  updateList(List1, Head):- !,
  updateList([Head|List1], Head),!.
  
  
  %Check if proof is valid
  valid_proof(Prems, Goal, Proof) :-
     findlast(Proof, [_, Results, _]),
     Goal = Result,
     rows(Proof, Prems).
  
  
  %Helps to check if goal exists
  findlast([X], X).
  findlast([_|T], L) :- findlast(T, L).
  
  %Helps to check if premissess are correct
  premise([_, P, premise], Prems) :-
    member(P, Prems).
  
  %Check if premissess are correct
  rows([], Prems).
  rows([Head|Tail], Prems) :-
    premise(Head, Prems),
    rows(Tail, Prems).
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  %