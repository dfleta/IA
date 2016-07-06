
% el sistema devuelve como solución el estado Meta
% el programa muestra en salida estándar la solución:
% camino (S o NS) de nodos (estados) desde el inicial
% al meta (Meta)

% ------ invocar al sistema desde código fuente -----

evaluar(Meta):- solucion(20,[3/2,1/1,3/1,1/2,2/1,2/2,1/3,2/3,3/3],Meta,[]).


solucion(I,Estado,Estado,S):-
		test(Estado),
		anadir(Estado,S,NS),
		escribir(NS),nl,!.

solucion(I,Estado,Meta,S):-
		NI is I-1, NI>=0,
		% write(NI),nl,
		permuta(Estado,S,Sucesor),
		anadir(Estado,S,NS),
		solucion(NI,Sucesor,Meta,NS).

% -------- función sucesor --------

% ----- operador izq -----

permuta([X/Y|L],S,L1):-	
			X1 is X-1,
			member(X1,[1,2,3]),
			Y1=Y,
			cambio(X/Y,X1/Y1,L,L1),
			noExplorado(L1,S).

% ----- operador abajo -----

permuta([X/Y|L],S,L1):-	
			Y1 is Y+1,
			member(Y1,[1,2,3]),
			X1=X,
			cambio(X/Y,X1/Y1,L,L1),
			noExplorado(L1,S).		

% ----- operador der -----

permuta([X/Y|L],S,L1):-
			X1 is X+1,
			member(X1,[1,2,3]),
			Y1=Y,
			cambio(X/Y,X1/Y1,L,L1),
			noExplorado(L1,S).	

% ----- operador arriba -----

permuta([X/Y|L],S,L1):-		
			Y1 is Y-1,
			member(Y1,[1,2,3]),
			X1=X,
			cambio(X/Y,X1/Y1,L,L1),
			noExplorado(L1,S).
	
% -------- añadir nodo al camino = solución -----

anadir(Nodo,[],[Nodo|[]]).
anadir(Nodo,[Primero|S],[Nodo,Primero|S]).

% -------- el nodo ha sido explorado anteriormente ----

noExplorado(L1,S):-
			member(L1,S),!,fail;
			true.

% ------ permutar blanco con su adyacente ------

cambio(X/Y,X1/Y1,[X2/Y2|Resto],[X1/Y1,X/Y|Resto]):-
				X1=:=X2, Y1=:=Y2,!.

cambio(X/Y,X1/Y1,[X2/Y2|Resto],L1):-				
				cambio(X/Y,X1/Y1,Resto,L),
				mover(X2/Y2,L,L1).

mover(X2/Y2,[X1/Y1|Resto],[X1/Y1,X2/Y2|Resto]).


% ------ escribir solución (camino) en pantalla ------

escribir([]):-
		write('] fin de S'),nl.

escribir([Nodo|Resto]):-
		write('inicio S [ '),
		escribirNodo(Nodo),nl,
		escribir(Resto).

escribirNodo([]):-
		write('] fin nodo'),nl.

escribirNodo([X/Y|Resto]):-
		write(X/Y),write(','),
		escribirNodo(Resto).

% ----- función test -----

test([1/1,2/1,3/1,1/2,2/2,3/2,1/3,2/3,3/3]).

