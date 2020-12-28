% main menu
main_menu :-
    print_main_menu,
    read(Input),
    manage_input(Input).

% prints main menu
print_main_menu :-

    write('\n'),
    write('   _____    _      _            _____    _       _      \n'),
    write('  |_   _|  (_)    | |          |_   _|  (_)     | |     \n'),
    write('    | |_ __ _  ___| | ___   _    | |_ __ _ _ __ | | ___ \n'),
    write('    | | |__| |/ __| |/ / | | |   | | |__| | |_ || |/ _ |\n'),
    write('    | | |  | | (__|   <| |_| |   | | |  | | |_) | |  __/\n'),
    write('    |_/_|  |_||___|_||_||__, |   |_/_|  |_| .__/|_||___|\n'),
    write('                         __/ |            | |           \n'),
    write('                        |___/             |_|           \n'),
    write('\n'),

    write('Welcome to the Tricky Triple Solver! \n\n'),
    write('Put a 1, 2, or 3 in every white square. When 3 adjacent white squares are in a line horizontally, vertically, or diagonally, they should contain exactly 2 of one of those numbers. Each puzzle below has a unique solution.\n'),
    write('We are here to solve them!\n\n'),
    
    write('1. Easy\n'),
    write('2. Medium\n'),
    write('3. Hard\n\n'),
    write('0. Exit\n\n'),
    write('Insert your option >').


% manages user input
% if 1: Easy
% if 2: Medium
% if 3: Hard
manage_input(1) :-
    print_level_easy,
    read(Input),
    manage_level_easy_input(Input),
    main_menu.
manage_input(2) :-
    print_level_medium,
    read(Input),
    manage_level_medium_input(Input),
    main_menu.
manage_input(3) :-
    print_level_hard,
    read(Input),
    manage_level_hard_input(Input),
    main_menu.
manage_input(0) :-
    write('Exiting...\n').
manage_input(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    main_menu.

% easy menu
print_level_easy :-
    write('Here are some easy level puzzles. Which one do you want to see the solution to?\n'),
    write('1.                2.                3. \n'),
    write(' --- ---1--- '), write('     '), write('1--- ---3--- '), write('     '), write('2---1--- --- '), write('\n'),
    write('|   |   |   |'), write('     '), write('|   |   |   |'), write('     '), write('|   |   |   |'), write('\n'),
    write('2--- ---1--- '), write('     '), write(' --- --- --- '), write('     '), write(' ---3--- ---3'), write('\n'),
    write('|   |   |   |'), write('     '), write('|   |   |   |'), write('     '), write('|   |   |   |'), write('\n'),
    write(' --- --- ---2'), write('     '), write('2--- ---3---1'), write('     '), write(' --- --- ---3'), write('\n'),
    write('|   |   |   |'), write('     '), write('|   |   |   |'), write('     '), write('|   |   |   |'), write('\n'),
    write(' ---2--- ---3'), write('     '), write(' --- ---2--- '), write('     '), write('2--- --- --- '), write('\n\n'),
    write('Insert your option > ').

% medium menu
print_level_medium :-
    write('Here are some mediym level puzzles. Which one do you want to see the solution to?\n'),
    write('1.                    2.                    3. \n'),
    write('1--- --- ---2---3'), write('     '), write(' ---2--- ---1--- '), write('     '), write(' --- ---2--- ---2'), write('\n'),
    write('|   |   |   |   |'), write('     '), write('|   |   |   |   |'), write('     '), write('|   |   |   |   |'), write('\n'),
    write(' --- --- --- ---1'), write('     '), write(' --- --- --- --- '), write('     '), write(' ---1--- --- --- '), write('\n'),
    write('|   |   |   |   |'), write('     '), write('|   |   |   |   |'), write('     '), write('|   |   |   |   |'), write('\n'),
    write(' --- --- --- --- '), write('     '), write('1--- --- --- ---2'), write('     '), write(' ---1---0--- ---3'), write('\n'),
    write('|   |   |   |   |'), write('     '), write('|   |   |   |   |'), write('     '), write('|   |   |   |   |'), write('\n'),
    write('1--- --- --- ---2'), write('     '), write(' --- ---0--- --- '), write('     '), write('1--- ---3---1--- '), write('\n'),
    write('|   |   |   |   |'), write('     '), write('|   |   |   |   |'), write('     '), write('|   |   |   |   |'), write('\n'),
    write(' --- ---1--- --- '), write('     '), write('3---2--- ---3---1'), write('     '), write(' --- --- --- --- '), write('\n\n'),
    write('Insert your option >').

% hard menu
print_level_hard :-
    write('Not yet implemented :(').

% manage level easy option
manage_level_easy_input(1) :-
    %solveTrickyTriple(1).
    boardOne(Board),
    solveRecursively(Board).
manage_level_easy_input(2) :-
    boardTwo(Board),
    solveRecursively(Board).
    %solveTrickyTriple(2).
manage_level_easy_input(3) :-
    boardThree(Board),
    solveRecursively(Board).
    %solveTrickyTriple(3).
manage_level_easy_input(_Other) :-
    write('\nERROR: that option does not exist.\n\n').

% manage level medium option
manage_level_medium_input(1) :-
    boardSeven(Board),
    solveRecursively(Board).
manage_level_medium_input(2) :-
    boardEight(Board),
    solveRecursively(Board).
manage_level_medium_input(3) :-
    boardNine(Board),
    solveRecursively(Board).
manage_level_medium_input(_Other) :-
    write('\nERROR: that option does not exist.\n\n').

% manage level hard option
manage_level_hard_input(1) :-
    solveTrickyTriple(7).
manage_level_hard_input(2) :-
    solveTrickyTriple(8).
manage_level_hard_input(3) :-
    solveTrickyTriple(9).
manage_level_hard_input(_Other) :-
    write('\nERROR: that option does not exist.\n\n').
