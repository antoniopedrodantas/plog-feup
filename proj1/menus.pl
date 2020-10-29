main_menu :-
    print_main_menu,
    read(Input),
    manage_input(Input).

manage_input(1) :-
    start_game,
    main_menu.
manage_input(2) :-
    write('Exiting...\n').
manage_input(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    main_menu.

print_main_menu :-
    write('Welcome to Nava \n'),
    write('1. Play\n'),
    write('2. Exit\n\n'),
    write('Insert your option >').