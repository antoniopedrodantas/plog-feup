% starts game, first instantiates the board and then displays it
start_game :-
    initial(InitialBoard),
    display_game(InitialBoard).

% initializes board
initial([
    [empty, empty, empty, empty, [d-1, d-1, d-1, d-1, d-1, d-1]],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [[d-2, d-2, d-2, d-2, d-2, d-2], empty, empty, empty, empty]
]).

% displays board
display_game(X) :-
    write('\n\n'),
    write('|  |   |   |   |   |   |\n'),
    print_matrix(X),
    write('\n\n').

% iterates through rows 
print_matrix([]).
print_matrix([Head|Tail]) :-
    write('|--'),
    print_line(Head),
    write('|  |   |   |   |   |   |\n'),
    print_matrix(Tail).

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
