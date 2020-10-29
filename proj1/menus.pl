% main menu
main_menu :-
    print_main_menu,
    read(Input),
    manage_input(Input).

% manages user input
% if 1: starts game
% if 2: terminates program
manage_input(1) :-
    start_game,
    main_menu.
manage_input(2) :-
    write('Exiting...\n').
manage_input(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    main_menu.

% prints main menu
print_main_menu :-
    write('Welcome to Nava \n'),
    write('1. Play\n'),
    write('2. Exit\n\n'),
    write('Insert your option >').