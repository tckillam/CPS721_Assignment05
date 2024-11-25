% Enter the names of your group members below.
% If you only have 2 group members, leave the last space blank
%
%%%%%
%%%%% NAME: 
%%%%% NAME:
%%%%% NAME:
%
% Add the required rules in the corresponding sections. 
% If you put the rules in the wrong sections, you will lose marks.
%
% You may add additional comments as you choose but DO NOT MODIFY the comment lines below
%

%%%%% SECTION: robocup_setup
%%%%%
%%%%% These lines allow you to write statements for a predicate that are not consecutive in your program
%%%%% Doing so enables the specification of an initial state in another file
%%%%% DO NOT MODIFY THE CODE IN THIS SECTION
:- dynamic hasBall/2.
:- dynamic robotLoc/4.
:- dynamic scored/1.

%%%%% This line loads the generic planner code from the file "planner.pl"
%%%%% Just ensure that that the planner.pl file is in the same directory as this one
:- [planner].

%%%%% SECTION: init_robocup
%%%%% Loads the initial state from either robocupInit1.pl or robocupInit2.pl
%%%%% Just leave whichever one uncommented that you want to test on
%%%%% NOTE, you can only uncomment one at a time
%%%%% HINT: You can create other files with other initial states to more easily test individual actions
%%%%%       To do so, just replace the line below with one loading in the file with your initial state
%:- [robocupInit1].
:- [robocupInit2].

%%%%% SECTION: goal_states_robocup
%%%%% Below we define different goal states, each with a different ID
%%%%% HINT: It may be useful to define "easier" goals when starting your program or when debugging
%%%%%       You can do so by adding more goal states below
%%%%% Goal XY should be read as goal Y for problem X

%% Goal states for robocupInit1
goal_state(11, S) :- robotLoc(r1, 0, 1, S).
goal_state(12, S) :- hasBall(r2, S).
goal_state(13, S) :- hasBall(r3, S).
goal_state(14, S) :- scored(S). 
goal_state(15, S) :- robotLoc(r1, 2, 2, S).
goal_state(16, S) :- robotLoc(r1, 3, 2, S).

%% Goal states for robocupInit1
goal_state(21, S) :- scored(S). 
goal_state(22, S) :- robotLoc(r1, 2, 4, S).

%%%%% SECTION: precondition_axioms_robocup
%%%%% Write precondition axioms for all actions in your domain. Recall that to avoid
%%%%% potential problems with negation in Prolog, you should not start bodies of your
%%%%% rules with negated predicates. Make sure that all variables in a predicate 
%%%%% are instantiated by constants before you apply negation to the predicate that 
%%%%% mentions these variables.

% check adjacency (non-diagonal movement)
adjacent(Row1, Col1, Row2, Col2) :- Row1 is Row2 , Col2 is Col1 + 1.
adjacent(Row1, Col1, Row2, Col2) :- Row1 is Row2 , Col1 is Col2 + 1.
adjacent(Row1, Col1, Row2, Col2) :- Col1 is Col2 , Row1 is Row2 + 1.
adjacent(Row1, Col1, Row2, Col2) :- Col1 is Col2 , Row2 is Row1 + 1.


% check a position is in boundaries
in_bounds(Row, Col) :-
    numRows(NumRows),
    numCols(NumCols),
    Row >= 0,
    Row < NumRows,
    Col >= 0,
    Col < NumCols.


% check a position is occupied by a robot or opponent
occupied(Row, Col, S) :-
    robotLoc(_, Row, Col, S).

occupied(Row, Col, _) :-
    opponentAt(Row, Col).

% Helper predicate to generate numbers exclusively between two numbers
between_exclusive_list(N1, N2, NsBetween) :-
    N1 < N2,
    NStart is N1 + 1,
    NEnd is N2 - 1,
    findall(N, between(NStart, NEnd, N), NsBetween).

between_exclusive_list(N1, N2, NsBetween) :-
    N1 > N2,
    NStart is N1 - 1,
    NEnd is N2 + 1,
    findall(N, between(NEnd, NStart, N), NsBetween).

between_exclusive_list(N1, N2, []) :-
    N1 = N2.

% Helper predicate to ensure no opponents are in the given columns for a row
noOpponentAtPositions(Row, Cols) :-
    forall(member(Col, Cols), not opponentAt(Row, Col)).

% Helper predicate to ensure no opponents are in the given rows for a column
noOpponentAtPositionsColumn(Rows, Col) :-
    forall(member(Row, Rows), not opponentAt(Row, Col)).

% Helper predicate to check for a clear path between two positions
clearPath(Row1, Col1, Row2, Col2, S) :-
    Row1 = Row2,
    not Col1 = Col2,
    between_exclusive_list(Col1, Col2, ColsBetween),
    noOpponentAtPositions(Row1, ColsBetween).

clearPath(Row1, Col1, Row2, Col2, S) :-
    Col1 = Col2,
    not Row1 = Row2,
    between_exclusive_list(Row1, Row2, RowsBetween),
    noOpponentAtPositionsColumn(RowsBetween, Col1).

% Helper predicate to check for a clear path to the goal
clearPathToGoal(Row, Col, S) :-
    Row > 0,
    findall(R, between(0, Row-1, R), RowsBetween),
    noOpponentAtPositionsColumn(RowsBetween, Col).

% Precondition for the move action
poss(move(Robot, Row1, Col1, Row2, Col2), S) :-
    robot(Robot),
    robotLoc(Robot, Row1, Col1, S),
    adjacent(Row1, Col1, Row2, Col2),
    in_bounds(Row2, Col2),
    (not Row1 = Row2 , not Col1 = Col2), % Prevent moving to the same location
    not occupied(Row2, Col2, S).

% Precondition for the pass action
poss(pass(Robot1, Robot2), S) :-
    robot(Robot1),
    robot(Robot2),
    Robot1 \= Robot2,
    hasBall(Robot1, S),
    robotLoc(Robot1, Row1, Col1, S),
    robotLoc(Robot2, Row2, Col2, S),
    ((Row1 = Row2, Col1 \= Col2);
     (Col1 = Col2, Row1 \= Row2)),
    clearPath(Row1, Col1, Row2, Col2, S).

% Precondition for the shoot action
poss(shoot(Robot), S) :-
    robot(Robot),
    hasBall(Robot, S),
    robotLoc(Robot, Row, Col, S),
    goalCol(Col),
    clearPathToGoal(Row, Col, S).



%%%%% SECTION: successor_state_axioms_robocup
%%%%% Write successor-state axioms that characterize how the truth value of all 
%%%%% fluents change from the current situation S to the next situation [A | S]. 
%%%%% You will need two types of rules for each fluent: 
%%%%% 	(a) rules that characterize when a fluent becomes true in the next situation 
%%%%%	as a result of the last action, and
%%%%%	(b) rules that characterize when a fluent remains true in the next situation,
%%%%%	unless the most recent action changes it to false.
%%%%% When you write successor state axioms, you can sometimes start bodies of rules 
%%%%% with negation of a predicate, e.g., with negation of equality. This can help 
%%%%% to make them a bit more efficient.
%%%%%
%%%%% Write your successor state rules here: you have to write brief comments %




%%%%% SECTION: declarative_heuristics_robocup
%%%%% The predicate useless(A,ListOfPastActions) is true if an action A is useless
%%%%% given the list of previously performed actions. The predicate useless(A,ListOfPastActions)
%%%%% helps to solve the planning problem by providing declarative heuristics to 
%%%%% the planner. If this predicate is correctly defined using a few rules, then it 
%%%%% helps to speed-up the search that your program is doing to find a list of actions
%%%%% that solves a planning problem. Write as many rules that define this predicate
%%%%% as you can: think about useless repetitions you would like to avoid, and about 
%%%%% order of execution (i.e., use common sense properties of the application domain). 
%%%%% Your rules have to be general enough to be applicable to any problem in your domain,
%%%%% in other words, they have to help in solving a planning problem for any instance
%%%%% (i.e., any initial and goal states).
%%%%%	
%%%%% write your rules implementing the predicate  useless(Action,History) here. %



