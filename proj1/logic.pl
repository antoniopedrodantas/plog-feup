% starts game, first instantiates the board and then displays it
start_game :-
    initial(InitialBoard),
    display_game(InitialBoard, 1).

% initializes board
initial([
    [empty, empty, empty, empty, [d-1, d-1, d-1, d-1, d-1, d-1]],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [[d-2, d-2, d-2, d-2, d-2, d-2], empty, empty, empty, empty]
]).

% displays board
display_game(GameState, Player) :-
    write('\n\n'),
    write('   a   b   c   d   e   \n'),
    write('   |   |   |   |   |   \n'),
    print_matrix(GameState, 1),
    write('\n'),
    write('P1: X0x9\n'),
    write('P2: Z0x9'),
    write('\n\n').

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
print_piece(empty) :-
    write('oo').
print_piece([Head|Tail]) :-
    print_head(Head),
    write('6').
print_piece(_Other) :-
    write('ERROR').

% gets type of piece and player
print_head(d-1) :-
    write('X').
print_head(d-2) :-
    write('Z').
