:- consult('utils.pl').

:- use_module(library(lists)).

% starts game, first instantiates the board and then displays it
start_game :-
    initial(InitialBoard),
    display_game(InitialBoard, 1).

% initializes board
% first element has board info
% second element has remaining cubes info
initial([
    [[[empty], [empty], [empty], [empty], [d-1, d-1, d-1, d-1, d-1, d-1]],
    [[empty], [empty], [empty], [empty], [empty]],
    [[empty], [empty], [empty], [empty], [empty]],
    [[empty], [empty], [empty], [empty], [empty]],
    [[d-2, d-2, d-2, d-2, d-2, d-2], [empty], [empty], [empty], [empty]]],
    9, 9
]).

% displays board
display_game([Board|Cubes], Player) :-
    write('\n\n'),
    write('   a   b   c   d   e   \n'),
    write('   |   |   |   |   |   \n'),
    print_matrix(Board, 1),
    write('\n'),
    print_cubes(Cubes),
    write('\n\n'),
    % test
    valid_moves(Board, Player, []).


print_cubes([P1|Tail]) :-
    write('P1: X0x'),
    write(P1),
    write('\nP2: Z0x'),
    first(Tail, P2),
    write(P2).

% iterates through rows 
print_matrix([], Iterator).
print_matrix([Head|Tail], Iterator) :-
    write(Iterator),
    write('--'),
    print_line(Head),
    write('   |   |   |   |   |   \n'),
    IteratorPlus is Iterator + 1,
    print_matrix(Tail, IteratorPlus).

% prints rows
print_line([]) :-
    write('|\n').
print_line([Head|Tail]) :-
    print_piece(Head),
    write('--'),
    print_line(Tail).

% prints a single piece
print_piece([empty]) :-
    write('oo').
print_piece([Head|Tail]) :-
    print_head(Head),
    list_length([Head|Tail], N),
    write(N).
print_piece(_Other) :-
    write('ERROR').

% gets type of piece and player
print_head(d-1) :-
    write('X').
print_head(d-2) :-
    write('Z').

% calculates list length -> list_length(+List, -N)
list_length([], 0).
list_length([_H|T], N) :- 
    length(T, N1),
    N is N1 + 1.

% gets valid moves of a given player
% valid_moves(+GameState, +Player, -ListOfMoves)
% 4 possible directions
% makes size of stack moved is <= number of places
valid_moves(Board, Player, ListOfMoves) :-
    find_pieces(Board, Player, PositionsPieces, Positions, 1),
    PositionsTmp = Positions,
    get_pieces(Board, PositionsTmp, [], Pieces),
    get_valid_moves(Positions, Pieces, [], ValidMoves),
    write('ValidMoves: '),
    write(ValidMoves),
    write('\n\n').

% gets a piece's possible up moves
check_up(Position, Piece, X, 1, L, ValidUpMovesTmp, ValidUpMovesTmp).
check_up(Position, Piece, X, Y, 0, ValidUpMovesTmp, ValidUpMovesTmp).
check_up(Position, Piece, X, Y, L, ValidUpMovesTmp, ValidUpMoves) :-
    YI is Y-1,
    LI is L-1,
    AsciiNumber is X + 96,
    char_code(Letter, AsciiNumber),
    append(ValidUpMovesTmp, [Position:YI-Letter], NewValidUpMoves),
    check_up(Position, Piece, X, YI, LI, NewValidUpMoves, ValidUpMoves).

% gets a piece's possible down moves
check_down(Position, Piece, X, 5, L, ValidDownMovesTmp, ValidDownMovesTmp).
check_down(Position, Piece, X, Y, 0, ValidDownMovesTmp, ValidDownMovesTmp).
check_down(Position, Piece, X, Y, L, ValidDownMovesTmp, ValidDownMoves) :-
    YI is Y+1,
    LI is L-1,
    AsciiNumber is X + 96,
    char_code(Letter, AsciiNumber),
    append(ValidDownMovesTmp, [Position:YI-Letter], NewValidDownMoves),
    check_down(Position, Piece, X, YI, LI, NewValidDownMoves, ValidDownMoves).

% gets a piece's possible left moves
check_left(Position, Piece, 1, Y, L, ValidLeftMovesTmp, ValidLeftMovesTmp).
check_left(Position, Piece, X, Y, 0, ValidLeftMovesTmp, ValidLeftMovesTmp).
check_left(Position, Piece, X, Y, L, ValidLeftMovesTmp, ValidLeftMoves) :-
    XI is X-1,
    LI is L-1,
    AsciiNumber is XI + 96,
    char_code(Letter, AsciiNumber),
    append(ValidLeftMovesTmp, [Position:Y-Letter], NewValidLeftMoves),
    check_left(Position, Piece, XI, Y, LI, NewValidLeftMoves, ValidLeftMoves).

% gets a piece's possible right moves
check_right(Position, Piece, 5, Y, L, ValidRightMovesTmp, ValidRightMovesTmp).
check_right(Position, Piece, X, Y, 0, ValidRightMovesTmp, ValidRightMovesTmp).
check_right(Position, Piece, X, Y, L, ValidRightMovesTmp, ValidRightMoves) :-
    XI is X+1,
    LI is L-1,
    AsciiNumber is XI + 96,
    char_code(Letter, AsciiNumber),
    append(ValidRightMovesTmp, [Position:Y-Letter], NewValidRightMoves),
    check_right(Position, Piece, XI, Y, LI, NewValidRightMoves, ValidRightMoves).

% get_valid_piece_moves(+Position, +Piece, -ValidPieceMoves)
get_valid_piece_moves(Position, Piece, ValidPieceMoves) :-
    get_coordinates(Position, Y, X),
    length(Piece, L),
    check_up(Position, Piece, X, Y, L, [], ValidUpMoves),
    append([], ValidUpMoves, VMU),
    check_down(Position, Piece, X, Y, L, [], ValidDownMoves),
    append(VMU, ValidDownMoves, VMD),
    check_left(Position, Piece, X, Y, L, [], ValidLeftMoves),
    append(VMD, ValidLeftMoves, VML),
    check_right(Position, Piece, X, Y, L, [], ValidRightMoves),
    append(VML, ValidRightMoves, ValidPieceMoves).

% get_valid_moves(+Positions, +Pieces, +ValidMovesTmp, -ValidMoves).
get_valid_moves([], [], ValidMovesTmp, ValidMovesTmp).
get_valid_moves(Positions, Pieces, ValidMovesTmp, ValidMoves) :-
    first(Positions, PosHead, PosTail),
    first(Pieces, PieHead, PieTail),
    get_valid_piece_moves(PosHead, PieHead, ValidPieceMoves),
    append(ValidMovesTmp, ValidPieceMoves, NewValidMoves),
    get_valid_moves(PosTail, PieTail, NewValidMoves, ValidMoves).

% decomposes position into numbers
position_numbers(X-Y, X, Y).

% get_coordinates(+Position, -X, -Y)-
get_coordinates(Position, X, Y) :-
    position_numbers(Position, X, YTmp),
    char_code(YTmp, Col),
    Y is Col - 96.

% this func will probably be used to get the valid moves for each piece
% get_pieces(+Positions, +PiecesAux, -Pieces).
get_pieces(Board, [], PiecesAux, PiecesAux).
get_pieces(Board, Positions, PiecesAux, Pieces) :-
    first(Positions, Position, Tail),
    get_coordinates(Position, X, Y),
    nth1(X, Board, ElemTmp),
    nth1(Y, ElemTmp, Elem),
    append(PiecesAux, [Elem], NewPieces),
    get_pieces(Board, Tail, NewPieces, Pieces).

% finds player's pieces in the game board
find_pieces([], Player, PositionsPieces, PositionsPieces, RowNumber).
find_pieces([Row|Tail], Player, PositionsPieces, Positions, RowNumber) :-
    find_row(Row, Player, Positions, PositionsPieces, PositionsRow, RowNumber, 97),
    RowPlus is RowNumber + 1,
    find_pieces(Tail, Player, PositionsRow, Positions, RowPlus).

% checks each row in 
find_row([], Player, Positions, PositionsPieces, PositionsPieces, Row, ColumnNumber).
find_row([Element|Tail], Player, Positions, PositionsPieces, PositionsRow, Row, ColumnNumber) :-
    first(Element, First),
    element(First, Player, PositionsPieces, NPositions, Row, ColumnNumber),
    ColumnPlus is ColumnNumber + 1,
    find_row(Tail, Player, Positions, NPositions, PositionsRow, Row, ColumnPlus).

% checks whose is element
element(d-1, 1, Positions, NPos, Row, Column) :-
    char_code(Letter, Column),
    append(Positions, [Row-Letter], NPos).
element(d-2, 2, Positions, NPos, Row, Column) :-
    char_code(Letter, Column),
    append(Positions, [Row-Letter], NPos).
element(_Other, Player, Positions, NPos, Row, Column) :-
    append(Positions, [], NPos).
