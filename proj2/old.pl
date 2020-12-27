% ------------------------ Easy Mode (4x4) ------------------------

% Level 1 
solveTrickyTriple(1) :-
    % Vars
    Vars = [A1, A2, A3, A4, B1, B2, B3, B4, C1, C2, C3, C4, D1, D2, D3, D4],
    domain(Vars, 1, 3),
    % Initial Values
    A3 #= 1,
    B1 #= 2,
    B3 #= 1,
    C4 #= 2,
    D2 #= 2,
    D4 #= 3,
    % Conditions
    % Horizontal
    condition(A1, A2, A3),
    condition(A2, A3, A4),
    condition(B1, B2, B3),
    condition(B2, B3, B4),
    condition(C1, C2, C3),
    condition(C2, C3, C4),
    condition(D1, D2, D3),
    condition(D2, D3, D4),
    % vertical
    condition(A1, B1, C1),
    condition(B1, C1, D1),
    condition(A2, B2, C2),
    condition(B2, C2, D2),
    condition(A3, B3, C3),
    condition(B3, C3, D3),
    condition(A4, B4, C4),
    condition(B4, C4, D4),
    % Diagonal
    condition(A1, B2, C3),
    condition(A2, B3, C4),
    condition(A3, B2, C1),
    condition(A4, B3, C2),
    condition(B1, C2, D3),
    condition(B2, C3, D4),
    condition(B3, C2, D1),
    condition(B4, C3, D2),
    % labels variables
    % labeling options : [], [ff], [ffc], [middle] 
    labeling([], Vars),
    % writes solution
    write('Solution: \n'),
    write(A1), write('---'), write(A2), write('---'), write(A3), write('---'), write(A4), write('\n'),
    write('|   |   |   |\n'),
    write(B1), write('---'), write(B2), write('---'), write(B3), write('---'), write(B4), write('\n'),
    write('|   |   |   |\n'),
    write(C1), write('---'), write(C2), write('---'), write(C3), write('---'), write(C4), write('\n'),
    write('|   |   |   |\n'),
    write(D1), write('---'), write(D2), write('---'), write(D3), write('---'), write(D4), write('\n'),
    write('\n').

% level 2
solveTrickyTriple(2) :-
    % Vars
    Vars = [A1, A2, A3, A4, B1, B2, B3, B4, C1, C2, C3, C4, D1, D2, D3, D4],
    domain(Vars, 1, 3),
    % Initial Values
    A1 #= 1,
    A3 #= 3,
    C1 #= 2,
    C3 #= 3,
    C4 #= 1,
    D3 #= 2,
    % Conditions
    % Horizontal
    condition(A1, A2, A3),
    condition(A2, A3, A4),
    condition(B1, B2, B3),
    condition(B2, B3, B4),
    condition(C1, C2, C3),
    condition(C2, C3, C4),
    condition(D1, D2, D3),
    condition(D2, D3, D4),
    % Vertical
    condition(A1, B1, C1),
    condition(B1, C1, D1),
    condition(A2, B2, C2),
    condition(B2, C2, D2),
    condition(A3, B3, C3),
    condition(B3, C3, D3),
    condition(A4, B4, C4),
    condition(B4, C4, D4),
    % Diagonal
    condition(A1, B2, C3),
    condition(A2, B3, C4),
    condition(A3, B2, C1),
    condition(A4, B3, C2),
    condition(B1, C2, D3),
    condition(B2, C3, D4),
    condition(B3, C2, D1),
    condition(B4, C3, D2),
    % labels variables
    labeling([], Vars),
    % writes solution
    write('Solution: \n'),
    write(A1), write('---'), write(A2), write('---'), write(A3), write('---'), write(A4), write('\n'),
    write('|   |   |   |\n'),
    write(B1), write('---'), write(B2), write('---'), write(B3), write('---'), write(B4), write('\n'),
    write('|   |   |   |\n'),
    write(C1), write('---'), write(C2), write('---'), write(C3), write('---'), write(C4), write('\n'),
    write('|   |   |   |\n'),
    write(D1), write('---'), write(D2), write('---'), write(D3), write('---'), write(D4), write('\n'),
    write('\n').

% level 3
solveTrickyTriple(3) :-
    % Vars
    Vars = [A1, A2, A3, A4, B1, B2, B3, B4, C1, C2, C3, C4, D1, D2, D3, D4],
    domain(Vars, 1, 3),
    % Initial Values
    A1 #= 2,
    A2 #= 2,
    C1 #= 3,
    C4 #= 1,
    D2 #= 3,
    D3 #= 1,
    % Conditions
    % Horizontal
    condition(A1, A2, A3),
    condition(A2, A3, A4),
    condition(B1, B2, B3),
    condition(B2, B3, B4),
    condition(C1, C2, C3),
    condition(C2, C3, C4),
    condition(D1, D2, D3),
    condition(D2, D3, D4),
    % Vertical
    condition(A1, B1, C1),
    condition(B1, C1, D1),
    condition(A2, B2, C2),
    condition(B2, C2, D2),
    condition(A3, B3, C3),
    condition(B3, C3, D3),
    condition(A4, B4, C4),
    condition(B4, C4, D4),
    % Diagonal
    condition(A1, B2, C3),
    condition(A2, B3, C4),
    condition(A3, B2, C1),
    condition(A4, B3, C2),
    condition(B1, C2, D3),
    condition(B2, C3, D4),
    condition(B3, C2, D1),
    condition(B4, C3, D2),
    % labels variables
    labeling([], Vars),
    % writes Solution
    write('Solution: \n'),
    write(A1), write('---'), write(A2), write('---'), write(A3), write('---'), write(A4), write('\n'),
    write('|   |   |   |\n'),
    write(B1), write('---'), write(B2), write('---'), write(B3), write('---'), write(B4), write('\n'),
    write('|   |   |   |\n'),
    write(C1), write('---'), write(C2), write('---'), write(C3), write('---'), write(C4), write('\n'),
    write('|   |   |   |\n'),
    write(D1), write('---'), write(D2), write('---'), write(D3), write('---'), write(D4), write('\n'),
    write('\n').

% ------------------------ Medium Mode (5x5) ------------------------

% level 1

% level 2

% level 3

% ------------------------ Hard Mode (6x6) ------------------------

% level 1

% level 2

% level 3
