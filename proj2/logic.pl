:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(between)).

% TODO:
% -----> Descobrir como se faz com os quadrados pretos
% -----> Adicionar mais niveis

% ------------------------ Some Board ------------------------

boardOne([
    [_, _, 1, _],
    [2, _, 1, _],
    [_, _, _, 2],
    [_, 2, _, 3]
]).

boardTwo([
    [_, _, 1, _, _],
    [2, _, 1, _, _],
    [_, _, _, 2, _],
    [_, 2, _, 3, _],
    [_, 2, _, 3, _]]
).

% ------------------------ Tricky Triple Logic ------------------------

% Possible 3 square layout
condition(A, B, C) :-
    A #= B,
    A #\= C.

condition(A, B, C) :-
    A #= C,
    A #\= B.


condition(A, B, C) :-
    B #= C,
    A #\= C.

% ------------------------ New Functions ------------------------

applyHorizontalConstraints(Board, Size, Length, Length, Column, Size).
applyHorizontalConstraints(Board, Size, Length, Row, Column, Size) :-
    NewRow is Row + 1,
    applyHorizontalConstraints(Board, Size, Length, NewRow, 1, 3).
applyHorizontalConstraints(Board, Size, Length, Row, Column, Max) :-
    % aux calculous
    AuxRow is Row - 1,
    AuxNumber is AuxRow * 4,
    % gets first element
    FirstIndex is Column + AuxNumber,
    nth1(FirstIndex, Board, Elem),
    % gets second element
    ColumnTwo is Column + 1,
    SecondIndex is ColumnTwo + AuxNumber,
    nth1(SecondIndex, Board, ElemTwo),
    % gets third element
    ColumnThree is Column + 2,
    ThirdIndex is ColumnThree + AuxNumber,
    nth1(ThirdIndex, Board, ElemThree),
    % restricts values
    condition(Elem, ElemTwo, ElemThree),
    % recursive calls
    NewMax is Max + 1,
    NewColumn is Column + 1,
    applyHorizontalConstraints(Board, Size, Length, Row, NewColumn, NewMax).

applyVerticalConstraints(Board, Size, Length, Row, Length, Size).
applyVerticalConstraints(Board, Size, Length, Row, Column, Size) :-
    NewColumn is Column + 1,
    applyVerticalConstraints(Board, Size, Length, 1, NewColumn, 3).
applyVerticalConstraints(Board, Size, Length, Row, Column, Max) :-
    % gets first element
    DecRow is Row - 1,
    AuxNumber is DecRow * 4,
    FirstIndex is Column + AuxNumber,
    nth1(FirstIndex, Board, Elem),
    % gets second element
    AuxNumberTwo is Row * 4,
    SecondIndex is Column + AuxNumberTwo,
    nth1(SecondIndex, Board, ElemTwo),
    % gets third element
    DecRowThree is Row + 1,
    AuxNumberThree is DecRowThree * 4,
    ThirdIndex is Column + AuxNumberThree,
    nth1(ThirdIndex, Board, ElemThree),
    % restricts values
    condition(Elem, ElemTwo, ElemThree),
    % recursive calls
    NewMax is Max + 1,
    NewRow is Row + 1,
    applyVerticalConstraints(Board, Size, Length, NewRow, Column, NewMax).


solveRecursively :-
    % chooses Board
    boardTwo(Board),
    % gets length and size 
    length(Board, Length),
    Size is Length + 1,
    % gets all variables
    append(Board, FlatBoard),
    domain(FlatBoard, 1, 3),
    % applies constraints
    applyHorizontalConstraints(FlatBoard, Size, Length, 1, 1, 3),
    applyVerticalConstraints(FlatBoard, Size, Length, 1, 1, 3),
    % labels variables
    labeling([], FlatBoard),
    % writes final board
    displayBoard(FlatBoard, Size, Length, 1, 1).

displayBoard(FlatBoard, Size, Length, Length, Size).
displayBoard(FlatBoard, Size, Length, Row, Size) :-
    write('\n'),
    NewRow is Row + 1,
    displayBoard(FlatBoard, Size, Length, NewRow, 1).
displayBoard(FlatBoard, Size, Length, Row, Column) :-
    AuxRow is Row - 1,
    AuxNumber is AuxRow * 4,
    Index is Column + AuxNumber,
    nth1(Index, FlatBoard, Elem),
    write(Elem), write(' '),
    NewColumn is Column + 1,
    displayBoard(FlatBoard, Size, Length, Row, NewColumn).


