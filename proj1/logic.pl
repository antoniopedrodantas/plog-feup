:- consult('utils.pl').
:- consult('movement.pl').

:- use_module(library(lists)).
:- use_module(library(random)).

% -----------------------------------------------------------------------------------------
% ------------------------------ Starting Environment -------------------------------------
% -----------------------------------------------------------------------------------------

% starts game, first instantiates the board and then displays it

%starts game for PvP
start_game(1) :-
    initial(InitialBoard),
    display_game(InitialBoard, 1).

%starts game for PvPC
start_game(2) :-
    initial(InitialBoard),
    display_game(InitialBoard, 3).

% initializes board
% first element has board info
% second element has remaining cubes info
initial([
    [[[empty], [empty], [empty], [empty], [empty]],
    [[empty], [empty], [empty], [d-1,d-1], [empty]],
    [[empty], [empty], [empty], [empty], [empty]],
    [[empty], [empty], [empty], [empty], [empty]],
    [[d-2, d-2, d-2, d-2, d-2, d-2], [empty], [empty], [empty], [empty]]],
    9, 9
]).

% -----------------------------------------------------------------------------------------
% ---------------------------------- Player vs Player -------------------------------------
% -----------------------------------------------------------------------------------------

% displays board for player 1
display_game([Board|Cubes], 1) :-
    write('\n\n'),
    write('   a   b   c   d   e   \n'),
    write('   |   |   |   |   |   \n'),
    print_matrix(Board, 1),
    write('\n'),
    print_cubes(Cubes),
    write('\n\n'),
    valid_moves(Board, 1, ListOfMoves),
    write('Player 1s turn.'),
    write('\n'),
    write('[Valid Moves]: '),
    write(ListOfMoves),
    write('\n\n'),
    get_players_move([Board|Cubes], ListOfMoves, NewGameState),
    game_over(NewGameState, Winner),
    end_game(Winner, 1, NewGameState).

% displays board for player 2
display_game([Board|Cubes], 2) :-
    write('\n\n'),
    write('   a   b   c   d   e   \n'),
    write('   |   |   |   |   |   \n'),
    print_matrix(Board, 1),
    write('\n'),
    print_cubes(Cubes),
    write('\n\n'),
    valid_moves(Board, 2, ListOfMoves),
    write('Player 2s turn.\n'),
    write('[Valid Moves]: '),
    write(ListOfMoves),
    write('\n\n'),
    get_players_move([Board|Cubes], ListOfMoves, NewGameState),
    game_over(NewGameState, Winner),
    end_game(Winner, 2, NewGameState).

% -----------------------------------------------------------------------------------------
% --------------------------------- Player vs Computer ------------------------------------
% -----------------------------------------------------------------------------------------

% displays board for player 1 when he comes against the PC
display_game([Board|Cubes], 3) :-
    write('\n\n'),
    write('   a   b   c   d   e   \n'),
    write('   |   |   |   |   |   \n'),
    print_matrix(Board, 1),
    write('\n'),
    print_cubes(Cubes),
    write('\n\n'),
    valid_moves(Board, 1, ListOfMoves),
    write('Player 1s turn.'),
    write('\n'),
    write('[Valid Moves]: '),
    write(ListOfMoves),
    write('\n\n'),
    get_players_move([Board|Cubes], ListOfMoves, NewGameState),
    game_over(NewGameState, Winner),
    write('Winner: '), write(Winner), write('\n'),
    end_game(Winner, 3, NewGameState).

% displays board for player 1 when he comes against the PC
display_game([Board|Cubes], 4) :-
    write('\n\n'),
    write('   a   b   c   d   e   \n'),
    write('   |   |   |   |   |   \n'),
    print_matrix(Board, 1),
    write('\n'),
    print_cubes(Cubes),
    write('\n\n'),
    valid_moves(Board, 2, ListOfMoves),
    write('Computers turn.\n'),
    write('[Valid Moves]: '),
    write(ListOfMoves),
    write('\n\n'),
    get_ai_move([Board|Cubes], ListOfMoves, NewGameState),
    game_over(NewGameState, Winner),
    write('Winner: '), write(Winner), write('\n'),
    end_game(Winner, 4, NewGameState).
    %get_players_move([Board|Cubes], ListOfMoves, NewGameState).
    % have isGameOver here !
    %write('NewGameState: '), write(NewGameState), write('\n').
    %display_game(NewGameState, 3).

% -----------------------------------------------------------------------------------------
% ------------------------------- Logic Behind All This -----------------------------------
% -----------------------------------------------------------------------------------------

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
    get_valid_moves(Positions, Pieces, [], ListOfMoves).

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

% checks if game is over
% game_over(+GameState, -Winner)
game_over([Board|Cubes], Winner) :-
   valid_moves(Board, 1, ListOfMoves1),
   valid_moves(Board, 2, ListOfMoves2),
   get_smaller_list(ListOfMoves1, ListOfMoves2, SmallerList, PF),
   check_winner(SmallerList, PF, Winner).


% checks if a player won
% check_winner(+LisOfMoves, +Player, -Player)
check_winner([], 1, 2).
check_winner([], 2, 1).
check_winner(_Other, Player, 0).

% returns the smaller list between two given lists
% get_smaller_list(+List1, +List2, -SmallerList, -PF)
get_smaller_list(ListOfMoves1, ListOfMoves2, SmallerList, PF) :-
    list_length(ListOfMoves1, L1),
    list_length(ListOfMoves2, L2),
    L1 > L2 -> 
    SmallerList = ListOfMoves2, PF = 2 ; SmallerList = ListOfMoves1, PF = 1.

% if there is a winner, ends game and states the winner, else continues game
% end_game(+Winner, +Player, +GameState)
end_game(0, 1, NewGameState) :- display_game(NewGameState, 2).
end_game(0, 2, NewGameState) :- display_game(NewGameState, 1).
end_game(0, 3, NewGameState) :- display_game(NewGameState, 4).
end_game(0, 4, NewGameState) :- display_game(NewGameState, 3).

end_game(1, 1, NewGameState) :- write('\nPlayer 1 wins the game ! :D \n\n').
end_game(1, 2, NewGameState) :- write('\nPlayer 1 wins the game ! :D \n\n').
end_game(2, 1, NewGameState) :- write('\nPlayer 2 wins the game ! :D \n\n').
end_game(2, 2, NewGameState) :- write('\nPlayer 2 wins the game ! :D \n\n').

end_game(1, 3, NewGameState) :- write('\nYou won the game ! :D \n\n').
end_game(1, 4, NewGameState) :- write('\nYou won the game ! :D \n\n').
end_game(2, 3, NewGameState) :- write('\nComputer won the game ! D: \n\n').
end_game(2, 4, NewGameState) :- write('\nComputer won the game ! D: \n\n').