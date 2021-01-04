% main menu
main_menu :-
    print_main_menu,
    read(Input),
    manage_input(Input).

% manages user input
% if 1: starts game
% if 2: terminates program
manage_input(1) :-
    start_game(1, 0),
    main_menu.
manage_input(2) :-
    print_level_menu,
    read(Input),
    start_game(2, Input),
    main_menu.
manage_input(0) :-
    write('Exiting...\n').
manage_input(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    main_menu.

% prints main menu
print_main_menu :-

    write('\n'),
    write(' ________________________________ \n'),
    write('|   ____    ____  __ __   ____   |\n'),
    write('|  |    |  /    ||  |  | /    |  |\n'),
    write('|  |  _  ||  o  ||  |  ||  o  |  |\n'),
    write('|  |  |  ||     ||  |  ||     |  |\n'),
    write('|  |  |  ||  _  ||  :  ||  _  |  |\n'),
    write('|  |  |  ||  |  | |   / |  |  |  |\n'),
    write('|  |__|__||__|__|  |_/  |__|__|  |\n'),
    write('|________________________________|\n'),
    write('\n\n'),

    write('Welcome to Nava| \n\n'),
    write('1. Player vs. Player\n'),
    write('2. Player vs. Computer\n\n'),
    write('0. Exit\n\n'),
    write('Insert your option >').

print_level_menu :-
    write('\n'),
    write('Do you want a stroll in the park? Or do you want a challenge?\n'),
    write('0. Easy\n'),
    write('1. Hard\n\n'),
    write('Choose your difficulty >').