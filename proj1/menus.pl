mainMenu :-
    printMainMenu,
    read(Input),
    manageInput(Input).

manageInput(1) :-
    startGame,
    mainMenu.
manageInput(2) :-
    write('Exiting...\n').
manageInput(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    mainMenu.

printMainMenu :-
    write('Welcome to Nava \n'),
    write('1. Play\n'),
    write('2. Exit\n\n'),
    write('Insert your option >').