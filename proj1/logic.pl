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
    [[empty], [empty], [d-1], [empty], [empty]],
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
list_length([H|T], N) :- 
    length(T, N1),
    N is N1 + 1.

% gets valid moves of a given player
% valid_moves(+GameState, +Player, -ListOfMoves)
% 4 possible directions
% makes size of stack moved is <= number of places
valid_moves(Board, Player, ListOfMoves) :-
    find_pieces(Board, Player, [], NPos),
    write(NPos),
    write('\n').

% finds player's pieces in the game board
find_pieces([], Player, Positions, NPos).
find_pieces([Row|Tail], Player, Positions, NPos) :-
    find_row(Row, Player, Positions, NPos),
    find_pieces(Tail, Player, NPos, NPos).

% checks each row in 
find_row([], Player, Positions, NPos).
find_row([Element|Tail], Player, Positions, NPos) :-
    first(Element, First),
    element(First, Player, Positions, NPositions),
    write(NPositions),
    write('\n'),
    find_row(Tail, Payer, NPositions, NPos).

% checks whose is element
element(d-1, 1, Positions, NPos) :-
    write('hey\n'),
    append(Positions, ['hey'], NPos).
element(d-2, 2, Positions, NPos) :-
    append(Positions, ['hey'], NPos).
element(_Other, Player, Positions, NPos) :-
    append(Positions, [], NPos).
