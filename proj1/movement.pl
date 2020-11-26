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



% ------------------------------------------------ moves piece ------------------------------------------------

check_counter(X, Y, X, Y, [empty], ElemFinal, ElemFinal).
check_counter(X, Y, X, Y, ElemCmp, ElemFinal, NewElem) :-
    append(ElemFinal, ElemCmp, NewElem).
check_counter(Counter, CounterY, XF, YF, ElemCmp, ElemFinal, ElemCmp).

%move_piece_row(+ElemFinal, +Counter, +CounterY, +XF, YF, +Board, -Row).
move_piece_row(ElemFinal, 6, CounterY, XF, YF, Board, RowTmp, RowTmp).
move_piece_row(ElemFinal, Counter, CounterY, XF, YF, Board, RowTmp, Row) :-
    nth1(CounterY, Board, ElemCmpTmp),
    nth1(Counter, ElemCmpTmp, ElemCmp),
    check_counter(Counter, CounterY, XF, YF, ElemCmp, ElemFinal, NewElem),
    append(RowTmp, [NewElem], NewRow),
    CounterPlus is Counter + 1,
    move_piece_row(ElemFinal, CounterPlus, CounterY, XF, YF, Board, NewRow, Row).

% move_piece(+ElemFinal, +Counter, +XF, +YF, +Board, +BoardTmp, -NewBoard).
move_piece(ElemFinal, 6, XF, YF, Board, BoardTmp, BoardTmp).
move_piece(ElemFinal, Counter, XF, YF, Board, BoardTmp, NewBoard) :-
    move_piece_row(ElemFinal, 1, Counter, XF, YF, Board, [], Row),
    append(BoardTmp, [Row], NewBoardTmp),
    CounterPlus is Counter + 1,
    move_piece(ElemFinal, CounterPlus, XF, YF, Board, NewBoardTmp, NewBoard).

% -------------------------------------------------------------------------------------------------------------

% --------------------------------------------- update moved piece --------------------------------------------

%check_update_counter
check_update_counter(X, Y, X, Y, ElemCmp, [], [empty]).
check_update_counter(X, Y, X, Y, ElemCmp, ElemRest, ElemRest).
check_update_counter(Counter, CounterY, XI, YI, ElemCmp, ElemRest, ElemCmp).

%update_piece_row(+ElemRest, +Counter, +CounterY, +XI, +YI, +Board, -Row).
update_piece_row(ElemRest, 6, CounterY, XI, YI, Board, RowTmp, RowTmp).
update_piece_row(ElemRest, Counter, CounterY, XI, YI, Board, RowTmp, Row) :-
    nth1(CounterY, Board, ElemCmpTmp),
    nth1(Counter, ElemCmpTmp, ElemCmp),
    check_update_counter(Counter, CounterY, XI, YI, ElemCmp, ElemRest, NewElem),
    append(RowTmp, [NewElem], NewRow),
    CounterPlus is Counter + 1,
    update_piece_row(ElemRest, CounterPlus, CounterY, XI, YI, Board, NewRow, Row).


%update_moved_piece(+ElemRest, +Counter, +XI, +YI, +Board, +BoardTmp, -NewBoard).
update_moved_piece(ElemRest, 6, XI, YI, Board, BoardTmp, BoardTmp).
update_moved_piece(ElemRest, Counter, XI, YI, Board, BoardTmp, NewBoard) :-
    update_piece_row(ElemRest, 1, Counter, XI, YI, Board, [], Row),
    append(BoardTmp, [Row], NewBoardTmp),
    CounterPlus is Counter + 1,
    update_moved_piece(ElemRest, CounterPlus, XI, YI, Board, NewBoardTmp, NewBoard).

% -------------------------------------------------------------------------------------------------------------

make_new_game_state(NewBoard, Cubes, [NewBoard|Cubes]).

% move(+GameState, +Move, -NewGameState).
move([Board|Cubes], Move, NewGameState) :-
    get_both_positions(Move, Position1, Position2),
    get_coordinates(Position1, YI, XI),
    nth1(YI, Board, Elem1Tmp),
    nth1(XI, Elem1Tmp, ElemInitial),
    get_coordinates(Position2, YF, XF),
    difference(XI, XF, YI, YF, XD, YD),
    Difference is YD + XD,
    split_at(Difference, ElemInitial, ElemFinal, ElemRest),
    %now we just have to move the elemFinal to Position2 and change the ElemInitial to ElemRest
    move_piece(ElemFinal, 1, XF, YF, Board, [], NewBoardTmp),
    update_moved_piece(ElemRest, 1, XI, YI, NewBoardTmp, [], NewBoard),
    %write('NewBoard: '), write(NewBoard), write('\n').
    make_new_game_state(NewBoard, Cubes, NewGameState).
    %write(Board).

% ------------------------------------------------------------ ai ------------------------------------------------        

get_ai_move(GameState, ListOfMoves, NewGameState) :-
    length(ListOfMoves, Length),
    random(1, Length, Index),
    nth1(Index, ListOfMoves, Move),
    move(GameState, Move, NewGameState).
