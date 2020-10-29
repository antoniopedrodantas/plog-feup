% starts game, first instantiates the board and then displays it
startGame :-
    initBoard(InitialBoard),
    displayGame(InitialBoard).

% initializes board
initBoard([
    [empty, empty, empty, empty, [d-1, d-1, d-1, d-1]],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [[d-2, d-2, d-2, d-2], empty, empty, empty, empty]
]).

% displays board
displayGame(X) :-
    write('\n\n'),
    write('|  |  |  |  |  |  |\n'),
    printMatrix(X),
    write('\n\n').

printMatrix([]).
printMatrix([Head|Tail]) :-
    write('|--'),
    printLine(Head),
    write('|  |  |  |  |  |  |\n'),
    printMatrix(Tail).

printLine([]) :-
    write('|\n').
printLine([Head|Tail]) :-
    printPiece(Head),
    write('--'),
    printLine(Tail).

printPiece(empty) :-
    write('o').
printPiece([Head|Tail]) :-
    write('x1').
printPiece(_Other) :-
    write('ERROR').