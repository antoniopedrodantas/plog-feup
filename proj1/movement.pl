:- use_module(library(lists)).

% split_at/4 --------------------------------------------------------------------
split_at(N,Xs,Take,Rest) :-
    split_at_(Xs,N,Take,Rest).

succ(N0, N1) :-
    ( properly_grounded(N0) 
        ->  N1 is N0 + 1
        ; properly_grounded(N1)
        ->  N1 > 0, N0 is N1 - 1
        ; otherwise 
        -> Ctx=context(succ/2,''),
          throw(error(instantiation_error,Ctx))
       ).

% succ/2 --------------------------------------------------------------------

properly_grounded(X):-
    (var(X) -> false
        ; 
    ( X >= 0
        -> true
        ; otherwise 
    -> Ctx = context(succ/2,X),
        E=domain_error(not_less_than_zero,X),
       throw(error(E,Ctx));otherwise
       )
   ).

% split_at --------------------------------------------------------------------

split_at_(Rest, 0, [], Rest) :- !. % optimization
split_at_([], N, [], []) :-
    % cannot optimize here because (+, -, -, -) would be wrong,
    % which could possibly be a useful generator.
    N > 0.
split_at_([X|Xs], N, [X|Take], Rest) :-
    N > 0,
    succ(N0, N),
    split_at_(Xs, N0, Take, Rest).

% get_players_move(+GameState, +ListOfMoves, -NewGameState).
% if player chooses a valid move then we call move function
% else he just gets asked again for a new move
get_players_move(GameState, ListOfMoves, NewGameState) :-
    write('Choose your move: '),
    read(Input),
    on(Input, ListOfMoves) -> move(GameState, Input, NewGameState); write('That move is not valid!\n'), get_players_move(GameState, ListOfMoves, NewGameState).

% checks of input is on the ListOfMoves
on(Input,[Input|Rest]).
on(Input,[Head|Tail]):-
    on(Input,Tail).

% get_both_positions(+Move, -Position1, -Position2).
get_both_positions(Move, Position1, Position2) :-
    Move = Position1:Position2.

abs(X, Y) :-
    X > 0 -> Y is X + 0; Y is -X.

difference(X, X, YI, YF, XD, YD) :-
    YFTmp is YI - YF,
    abs(YFTmp, YD),
    XD is X - X.

difference(XI, XF, Y, Y, XD, YD) :-
    XFTmp is XI - XF,
    abs(XFTmp, XD),
    YD is Y - Y.

% move(+GameState, +Move, -NewGameState).
move([Board|Cubes], Move, NewGameState) :-
    get_both_positions(Move, Position1, Position2),
    get_coordinates(Position1, YI, XI),
    nth1(YI, Board, Elem1Tmp),
    nth1(XI, Elem1Tmp, ElemInitial),
    get_coordinates(Position2, YF, XF),
    write('Moved Elem: '), write(XI), write(' '), write(YI), write('\n'),
    write('Current Final Elem: '), write(XF), write(' '), write(YF), write('\n'),
    difference(XI, XF, YI, YF, XD, YD),
    write('Differences: '), write(XD), write(','), write(YD), write('\n'),
    Difference is YD + XD,
    write(Difference),
    write('\n'),
    write(ElemInitial),
    write('\n\n'),
    split_at(Difference, ElemInitial, ElemFinal, ElemRest),
    write('ElemFinal: '), write(ElemFinal), write('\n'),
    write('ElemRest: '), write(ElemRest), write('\n').
    %now we just have to move the elemFinal to Position2 and change the ElemInitial to ElemRest
