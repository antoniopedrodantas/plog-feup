% main menu
main_menu :-
    print_main_menu,
    read(Input),
    manage_input(Input).

% manages user input
% if 1: starts game
% if 2: terminates program
manage_input(1) :-
    start_game(1),
    main_menu.
manage_input(2) :-
    start_game(2),
    main_menu.
manage_input(0) :-
    write('Exiting...\n').
manage_input(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    main_menu.

% prints main menu
print_main_menu :-
    write('Welcome to Nava \n'),
    write('1. Player vs. Player\n'),
    write('2. Play vs. Computer\n\n'),
    write('0. Exit\n\n'),
    write('Insert your option >').