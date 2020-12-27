:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(between)).

% TODO:
% -----> Descobrir como se faz com os quadrados pretos
% -----> Adicionar mais niveis

% ------------------------ Tricky Triple Restriction ------------------------

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

% ------------------------ Horizontal Constraint ------------------------

applyHorizontalConstraints(Board, Size, Length, Length, Column, Size).
applyHorizontalConstraints(Board, Size, Length, Row, Column, Size) :-
    NewRow is Row + 1,
    applyHorizontalConstraints(Board, Size, Length, NewRow, 1, 3).
applyHorizontalConstraints(Board, Size, Length, Row, Column, Max) :-
    % aux calculous
    AuxRow is Row - 1,
    AuxNumber is AuxRow * Length,
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

% ------------------------ Vertical Constraint ------------------------

applyVerticalConstraints(Board, Size, Length, Row, Length, Size).
applyVerticalConstraints(Board, Size, Length, Row, Column, Size) :-
    NewColumn is Column + 1,
    applyVerticalConstraints(Board, Size, Length, 1, NewColumn, 3).
applyVerticalConstraints(Board, Size, Length, Row, Column, Max) :-
    % gets first element
    DecRow is Row - 1,
    AuxNumber is DecRow * Length,
    FirstIndex is Column + AuxNumber,
    nth1(FirstIndex, Board, Elem),
    % gets second element
    AuxNumberTwo is Row * Length,
    SecondIndex is Column + AuxNumberTwo,
    nth1(SecondIndex, Board, ElemTwo),
    % gets third element
    DecRowThree is Row + 1,
    AuxNumberThree is DecRowThree * Length,
    ThirdIndex is Column + AuxNumberThree,
    nth1(ThirdIndex, Board, ElemThree),
    % restricts values
    condition(Elem, ElemTwo, ElemThree),
    % recursive calls
    NewMax is Max + 1,
    NewRow is Row + 1,
    applyVerticalConstraints(Board, Size, Length, NewRow, Column, NewMax).

% ------------------------ Diagonal Constraints ------------------------
% ------------------------ Right Constraint ------------------------

applyDiagonalRightConstraint(Board, Size, Length, Row, Column, Size, Length).
applyDiagonalRightConstraint(Board, Size, Length, Row, Column, Size, MaxV) :-
    NewRow is Row + 1,
    NewMaxV is MaxV + 1,
    applyDiagonalRightConstraint(Board, Size, Length, NewRow, 1, 3, NewMaxV).
applyDiagonalRightConstraint(Board, Size, Length, Row, Column, MaxH, MaxV) :-
    % gets first element
    AuxRow is Row - 1,
    AuxNumber is AuxRow * Length,
    Index is Column + AuxNumber,
    nth1(Index, Board, Elem),
    % gets second element
    RowTwo is Row + 1,
    AuxRowTwo is RowTwo - 1,
    AuxNumberTwo is AuxRowTwo * Length,
    ColumnTwo is Column + 1,
    IndexTwo is ColumnTwo + AuxNumberTwo,
    nth1(IndexTwo, Board, ElemTwo),
    % gets third element
    RowThree is Row + 2,
    AuxRowThree is RowThree - 1,
    AuxNumberThree is AuxRowThree * Length,
    ColumnThree is Column + 2,
    IndexThree is ColumnThree + AuxNumberThree,
    nth1(IndexThree, Board, ElemThree),
    % restricts values
    condition(Elem, ElemTwo, ElemThree),
    % recursive calls
    NewMaxH is MaxH + 1,
    NewColumn is Column + 1,
    applyDiagonalRightConstraint(Board, Size, Length, Row, NewColumn, NewMaxH, MaxV).

% ------------------------ Left Constraint ------------------------

applyDiagonalLeftConstraint(Board, Size, Length, Row, Column, 0, Length).
applyDiagonalLeftConstraint(Board, Size, Length, Row, Column, 0, MaxV) :-
    NewRow is Row + 1,
    NewMaxV is MaxV + 1,
    MaxH is Size - 3,
    applyDiagonalLeftConstraint(Board, Size, Length, NewRow, Length, MaxH, NewMaxV).
applyDiagonalLeftConstraint(Board, Size, Length, Row, Column, MaxH, MaxV) :-
    % gets first element
    AuxRow is Row - 1,
    AuxNumber is AuxRow * Length,
    Index is Column + AuxNumber,
    nth1(Index, Board, Elem),
    % gets second element
    RowTwo is Row + 1,
    AuxRowTwo is RowTwo - 1,
    AuxNumberTwo is AuxRowTwo * Length,
    ColumnTwo is Column - 1,
    IndexTwo is ColumnTwo + AuxNumberTwo,
    nth1(IndexTwo, Board, ElemTwo),
    % gets third element
    RowThree is Row + 2,
    AuxRowThree is RowThree - 1,
    AuxNumberThree is AuxRowThree * Length,
    ColumnThree is Column - 2,
    IndexThree is ColumnThree + AuxNumberThree,
    nth1(IndexThree, Board, ElemThree),
    % restricts values
    condition(Elem, ElemTwo, ElemThree),
    % recursive calls
    NewMaxH is MaxH - 1,
    NewColumn is Column - 1,
    applyDiagonalLeftConstraint(Board, Size, Length, Row, NewColumn, NewMaxH, MaxV).

% ------------------------ Solving Function ------------------------

solveRecursively(Board) :-
    % gets length and size 
    length(Board, Length),
    Size is Length + 1,
    % gets all variables
    append(Board, FlatBoard),
    domain(FlatBoard, 1, 3),
    % applies constraints
    applyHorizontalConstraints(FlatBoard, Size, Length, 1, 1, 3),
    applyVerticalConstraints(FlatBoard, Size, Length, 1, 1, 3),
    applyDiagonalRightConstraint(FlatBoard, Size, Length, 1, 1, 3, 3),
    MaxH is Size - 3,
    applyDiagonalLeftConstraint(FlatBoard, Size, Length, 1, Length, MaxH, 3),
    % labels variables
    labeling([], FlatBoard),
    % writes final board
    displaySolution(FlatBoard, Size, Length, 1, 1).

% ------------------------ Final Board Display ------------------------

displaySolution(Board, Size, Length, Row, Column) :-
    write('\nSolution: \n'),
    displayBoard(Board, Size, Length, Row, Column),
    write('\n').

displayBoard(FlatBoard, Size, Length, Length, Size).
displayBoard(FlatBoard, Size, Length, Row, Size) :-
    write('\n|   |   |   |   \n'),
    NewRow is Row + 1,
    displayBoard(FlatBoard, Size, Length, NewRow, 1).
displayBoard(FlatBoard, Size, Length, Row, Column) :-
    Column = Length,
    AuxRow is Row - 1,
    AuxNumber is AuxRow * Length,
    Index is Column + AuxNumber,
    nth1(Index, FlatBoard, Elem),
    write(Elem),
    NewColumn is Column + 1,
    displayBoard(FlatBoard, Size, Length, Row, NewColumn).
displayBoard(FlatBoard, Size, Length, Row, Column) :-
    AuxRow is Row - 1,
    AuxNumber is AuxRow * Length,
    Index is Column + AuxNumber,
    nth1(Index, FlatBoard, Elem),
    write(Elem), write('---'),
    NewColumn is Column + 1,
    displayBoard(FlatBoard, Size, Length, Row, NewColumn).
