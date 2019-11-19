/*
Predikatet verify tar en inputfil och sparar filens premisser, mål och beviset i
variablerna Prems, Goal och Proof. Dessa tre variabler skickas sedan till predikatet valid_proof
som påbörjar kontrollen.
*/

verify(InputFileName) :- see(InputFileName),
read(Prems), read(Goal), read(Proof),
seen, valid_proof(Prems, Goal, Proof).



/*Predikat för att uppdatera listan med kontrollerade rader */

addList(List1, Element, [Element|List1]).


updateList([Element|List1], Element).
updateList(List1, Element):- !,
updateList([Element|List1], Element),!.


/**
Predikat som kopierar lista 1 till lista 2
*/
copyList([],[]).
copyList([H|T1],[H|T2]) :- copyList(T1,T2).

/**
Kontrollerar om sista raden av beviset stämmer överens med målet. 
Samt kontrollerar att beviset är korrekt.
*/
valid_proof(Prems, Goal, Proof):-
check_goal(Goal, Proof), check_proof(Proof, []).

/**
Kontrollerar om sista raden av beviset stämmer överens med målet. 
*/
check_goal(G, Proof):-
findLastProof(Proof, X), G = X, !.

/**
Itererar igenom beviset, returnerar resultatet i X.
*/
findLastProof([[_, Last, _]|[]], Last).
findLastProof([First|Tail], X):-
findLastProof(Tail, X).

/**
Itererar igenom beviset rad för rad. Kontrollerar varje rad med check_line och sparar varje rad till en lista
som kan användas för att kontrollera kommande rader genteemot.
*/
check_proof([], _).
check_proof([H|T], CheckedProof):-
check_line(H, CheckedProof), addList(CheckedProof, H, NewCheckedProof), check_proof(T, NewCheckedProof).

/**
Delen av programmet som kontrollerar validiteten av varje rad.
*/

/**
Om check_line anropas med en rad som innehåller premisser kontrolleras att denna premiss finns med i listan av premisser som gavs input.
*/
check_line([_, P, premise],_):-!,
member(P, Prems), !.


/**
Om check_line anropas med en rad som innehåller användning av en godtycklig regel exempelvis andel kontrolleras att det
eliminerade elementet finns bundet genom konjunktion till ett annat element i listan av tidigare kontrollerade rader.
Raden mönstermatchas till rätt regel.
*/
check_line([_, P, andel1(Line)], CheckedProof):-!,
member([Line, and(P, _), _], CheckedProof), !.

check_line([_, P, andel2(Line)], CheckedProof):-!,
member([Line, and(_, P), _], CheckedProof), !.

check_line([_, P, copy(Line)], CheckedProof):-!,
member([Line, P, _], CheckedProof), !.

check_line([_, and(X, Y), andint(Line1, Line2)], CheckedProof):-!,
member([Line1, X, _], CheckedProof), member([Line2, Y, _], CheckedProof), write("andint performed").

check_line([_, or(X, _), orint1(Line)], CheckedProof):-!,
member([Line, X, _], CheckedProof), !.

check_line([_, or(_, Y), orint2(Line)], CheckedProof):- !,
member([Line, Y, _], CheckedProof), !.

check_line([_, P, impel(Line1, Line2)], CheckedProof):-!,
member([Line1, P1, _], CheckedProof),!, member([Line2, imp(P1, P), _], CheckedProof),!.

check_line([_, neg(neg(P)), negnegint(Line)], CheckedProof):-!,
member([Line, P, _], CheckedProof), !.

check_line([_, P, negnegel(Line)], CheckedProof):-!,
member([Line, neg(neg(P)), _], CheckedProof),!.

check_line([_, neg(P), mt(Line1, Line2)], CheckedProof):-!,
member([Line1, imp(P, Q), _], CheckedProof), !, member([Line2, neg(Q), _], CheckedProof), !.

check_line([_, or(P, neg(P)), lem], CheckedProof):-!,
true, !.

check_line([[Startline, Assumption, assumption]|Restofbox], CheckedProof):-!,
copyList(CheckedProof, TemporaryCheckedProof), updateList(CheckedProof, [Startline, Assumption, assumption]), check_box([[Startline, Assumption, assumption]|Restofbox], TemporaryCheckedProof, CheckedProof).

check_line([_, P, contel(Line)], CheckedProof):-!,
member([Line, cont, _], CheckedProof), !.

check_line([_, cont, negel(Line1, Line2)], CheckedProof):-!,
member([Line1, P, _], CheckedProof), member([Line2, neg(P), _], CheckedProof), !.

/**
Boxhantering
*/

check_line([_, imp(P, Q), impint(Line1, Line2)], CheckedProof):-!,
findBox(Line1, Line2, CheckedProof, [Line1, P, assumption], [Line2, Q, _]).


check_line([_, Assumption, assumption], CheckedProof):-!,
true.

check_line([_, P, pbc(Line1, Line2)], CheckedProof):-!,
findBox(Line1, Line2, CheckedProof, [Line1, neg(P), assumption], [Line2, cont, _]).

check_line([_, X, orel(Line1, Line2, Line3, Line4, Line5)], CheckedProof):-!,
member([Line1, or(P, Q), _], CheckedProof), findBox(Line2, Line3, CheckedProof, [Line2, P, assumption], [Line3, X, _]),
findBox(Line4, Line5, CheckedProof, [Line4, Q, assumption], [Line5, X, _]).

check_line([_, P, negint(Line1, Line2)], CheckedProof):-!,
findBox(Line1, Line2, CheckedProof, [Line1, neg(P), assumption], [Line2, cont, _]).


/**
Kontrollera validiteten rad för rad inuti boxen genom att skicka varje rad till check_line. När detta är klart adderas hela boxen till listan med kontrollerade rader.
*/
check_box([], List, List2):- true.
check_box([Head|[]], TemporaryCheckedProof, [H|CheckedProof]).
check_box([H|T], TemporaryCheckedProof, CheckedProof):- !,
check_line(H, TemporaryCheckedProof), addList(TemporaryCheckedProof, H, NewCheckedProof), check_box(T, NewCheckedProof, CheckedProof).

findBox(Line1, Line2, [[Line1, Assumption, assumption]|Tail], [Line1, Assumption, assumption], Lastline).
findBox(Line1, Line2, [H|T], Firstline, Lastline):- !,
getLast(Line2, Tail, Lastline),!, findBox(Line1, Line2, [[Line1, Assumption, assumption]|Tail], [Line1, Assumption, assumption], Lastline), !.

/*
Hitta sista elementet i en lista
*/

getLast(Line2, [Head|[]], Head).
getLast(Line2, [H|T], Lastline):-
getLast(Line2, T, Lastline).