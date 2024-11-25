% Enter the names of your group members below.
% If you only have 2 group members, leave the last space blank
%
%%%%%
%%%%% NAME: Shaghayegh Dehghanisanij
%%%%% NAME: Theresa Killam
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
:- [robocupInit1].
%:- [robocupInit2].

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

/*
this action means Robot moves from the location of
Row1, Col1 to Row2, Col2. Robots can only move one row or column at a time, and cannot
move diagonally. They also cannot move into a location where there is another robot or an
opponent. A robot does not need to have the ball to move. For example, in Figure 1, r5 can
move to row 3, column 1 in a single step, but they cannot move to row 3, column 0 or row 4,
column 1 in a single step. Note that a robot cannot move off the field. A robot can also not
move to the same location they are already at (ie. move(R, 1, 2, 1, 2) is not a valid action).

opponentAt(Row, Col)

robotLoc(Robot, Row, Col, S)

Row1 >= 0, Row1 < numRows(X), Row2 >= 0, Row2 < numRows(X),
Col1 >= 0, Col1 < numRows(X), Col2 >= 0, Col2 < numCols(X), 

*/
% use robotLoc
poss(move(Robot, Row1, Col1, Row2, Col2), S) :- robotLoc(Robot, Row1, Col1, S), Row2 is Row1 - 1, Col2 is Col1, 
                                                Row1 >= 0, numRows(X), Row1 < X, Row2 >= 0, Row2 < X,
                                                Col1 >= 0, numCols(Y), Col1 < Y, Col2 >= 0, Col2 < Y,
                                                not (opponentAt(Row3, Col3), Row2=Row3, Col2=Col3), 
                                                not (robotLoc(Robot2, Row3, Col3, S), Row2=Row3, Col2=Col3, not Robot=Robot2).

poss(move(Robot, Row1, Col1, Row2, Col2), S) :- robotLoc(Robot, Row1, Col1, S), Row2 is Row1 + 1, Col2 is Col1,  
                                                Row1 >= 0, numRows(X), Row1 < X, Row2 >= 0, Row2 < X,
                                                Col1 >= 0, numCols(Y), Col1 < Y, Col2 >= 0, Col2 < Y,
                                                not (opponentAt(Row3, Col3), Row2=Row3, Col2=Col3), 
                                                not (robotLoc(Robot2, Row3, Col3, S), Row2=Row3, Col2=Col3, not Robot=Robot2).

poss(move(Robot, Row1, Col1, Row2, Col2), S) :- robotLoc(Robot, Row1, Col1, S), Col2 is Col1 - 1, Row2 is Row1,  
                                                Row1 >= 0, numRows(X), Row1 < X, Row2 >= 0, Row2 < X,
                                                Col1 >= 0, numCols(Y), Col1 < Y, Col2 >= 0, Col2 < Y,
                                                not (opponentAt(Row3, Col3), Row2=Row3, Col2=Col3), 
                                                not (robotLoc(Robot2, Row3, Col3, S), Row2=Row3, Col2=Col3, not Robot=Robot2).
                                                
poss(move(Robot, Row1, Col1, Row2, Col2), S) :- robotLoc(Robot, Row1, Col1, S), Col2 is Col1 + 1, Row2 is Row1,  
                                                Row1 >= 0, numRows(X), Row1 < X, Row2 >= 0, Row2 < X,
                                                Col1 >= 0, numCols(Y), Col1 < Y, Col2 >= 0, Col2 < Y,
                                                not (opponentAt(Row3, Col3), Row2=Row3, Col2=Col3), 
                                                not (robotLoc(Robot2, Row3, Col3, S), Row2=Row3, Col2=Col3, not Robot=Robot2).


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

/*
 Robot is at row Row and column Col in situation S.
*/
robotLoc(Robot, Row, Column, [move(Robot, Row1, Column1, Row, Column)|S]) :- not Row=Row1, Column=Column1,
                                                                             Row1 >= 0, numRows(X), Row1 < X, Row >= 0, Row < X,
                                                                             Column1 >= 0, numCols(Y), Column1 < Y, Column >= 0, Column < Y.
robotLoc(Robot, Row, Column, [move(Robot, Row1, Column1, Row, Column)|S]) :- Row=Row1, not Column=Column1,
                                                                             Row1 >= 0, numRows(X), Row1 < X, Row >= 0, Row < X,
                                                                             Column1 >= 0, numCols(Y), Column1 < Y, Column >= 0, Column < Y.
robotLoc(Robot, Row, Column, [A|S]) :- not A=move(Robot, Row1, Column1, Row, Column), not Row=Row1, Column=Column1,
                                                                             Row1 >= 0, numRows(X), Row1 < X, Row >= 0, Row < X,
                                                                             Column1 >= 0, numCols(Y), Column1 < Y, Column >= 0, Column < Y,
                                                                             robotLoc(Robot, Row, Column, S).
robotLoc(Robot, Row, Column, [A|S]) :- not A=move(Robot, Row1, Column1, Row, Column), Row=Row1, not Column=Column1,
                                                                             Row1 >= 0, numRows(X), Row1 < X, Row >= 0, Row < X,
                                                                             Column1 >= 0, numCols(Y), Column1 < Y, Column >= 0, Column < Y,
                                                                             robotLoc(Robot, Row, Column, S).

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



