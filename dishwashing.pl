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

%%%%% SECTION: dishwashing_setup
%%%%%
%%%%% These lines allow you to write statements for a predicate that are not consecutive in your program
%%%%% Doing so enables the specification of an initial state in another file
%%%%% DO NOT MODIFY THE CODE IN THIS SECTION
:- dynamic holding/2.
:- dynamic numHolding/2.
:- dynamic faucetOn/1.
:- dynamic loc/3.
:- dynamic wet/2.
:- dynamic dirty/2.
:- dynamic soapy/2.
:- dynamic plate/1.
:- dynamic glassware/1.

%%%%% This line loads the generic planner code from the file "planner.pl"
%%%%% Just ensure that that the planner.pl file is in the same directory as this one
:- [planner].

%%%%% SECTION: init_dishwashing
%%%%% Loads the initial state from either dishwashingInit1.pl or dishwashingInit2.pl
%%%%% Just leave whichever one uncommented that you want to test on
%%%%% NOTE, you can only uncomment one at a time
%%%%% HINT: You can create other files with other initial states to more easily test individual actions
%%%%%       To do so, just replace the line below with one loading in the file with your initial state
:- [dishwashingInit1].
%:- [dishwashingInit2].
%:- [dishwashingInit3].

%%%%% SECTION: goal_states_dishwashing
%%%%% Below we define different goal states, each with a different ID
%%%%% HINT: It may be useful to define "easier" goals when starting your program or when debugging
%%%%%       You can do so by adding more goal states below

%% Goal states for dishwashingInit1
goal_state(11, S) :- holding(brush, S), soapy(brush, S).
goal_state(12, S) :- loc(brush, dish_rack, S), loc(sponge, counter, S).
goal_state(13, S) :- not dirty(g1, S), not soapy(g1, S).
goal_state(14, S) :- not dirty(g1, S), not soapy(g1, S), loc(g1, dish_rack, S), not faucetOn(S). 
goal_state(15, S) :- not dirty(g1, S), not soapy(g1, S), loc(g1, dish_rack, S), not soapy(brush, S),
                        loc(brush, dish_rack, S), not faucetOn(S). 

%% Goal states for dishwashingInit2
goal_state(21, S) :- not dirty(p1, S), not soapy(p1, S). 
goal_state(22, S) :- not dirty(p1, S), not soapy(p1, S), loc(p1, dish_rack, S), 
                        not dirty(p2, S), not soapy(p2, S), loc(p2, dish_rack, S).  

%% Goal states for dishwashingInit3
goal_state(31, S) :- not dirty(p1, S), not soapy(p1, S), not dirty(g1, S), not soapy(g1, S),
                        loc(p1, dish_rack, S), loc(g1, dish_rack, S).

%%%%% SECTION: aux_dishwashing
%%%%% Add any additional helpers here, including any additional rules needed for the auxiliary predicates
%%%%% DO NOT MODIFY THE CODE IN THIS SECTION
place(counter).
place(dish_rack).

scrubber(sponge).
scrubber(brush).

dish(X) :- glassware(X).
dish(X) :- plate(X).

item(X) :- glassware(X).
item(X) :- plate(X).
item(X) :- scrubber(X).

%%%%% SECTION: precondition_axioms_dishwashing
%%%%% Write precondition axioms for all actions in your domain. Recall that to avoid
%%%%% potential problems with negation in Prolog, you should not start bodies of your
%%%%% rules with negated predicates. Make sure that all variables in a predicate 
%%%%% are instantiated by constants before you apply negation to the predicate that 
%%%%% mentions these variables. 


/ 
it is possible to pickup an item X from place P when the item X is in that place P, when the robot
is not already holding onto that item and when the robot is not already holding 2 objects
/
poss(pickUp(X, P), S) :- loc(X, P, S), not (holding(X, S)), numHolding(C, S), not (C > 1).

/
• putDown(X, P): puts down item X to place P. Only applicable if X is being held by the robot.
After applying this action, X is no longer held by the robot.
/

poss(putDown(X, P), S) :- holding(X, S).

/
• turnOnFaucet: turns on the faucet. This action is only applicable if the robot has a free hand
(ie. it is holding at most one item) to turn on the faucet.
• turnOffFaucet: turns off the faucet. This action is only applicable if the robot has a free hand
to turn off the faucet.
/

poss(turnOnFaucet, S) :- numHolding(C, S), C < 2, not (faucetOn(S)).
poss(turnOffFaucet, S) :- numHolding(C, S), C < 2, faucetOn(S).

/
• addSoap(X): adds soap to X. This action is only applicable if X is a scrubber that is held by
the robot. The robot must have a free hand to add soap to the scrubber. The scrubber will be
soapy after adding soap.
/

poss(addSoap(X), S) :- holding(X, S), numHolding(1, S), scrubber(X). 

/

• scrub(X, Y): scrubs dish X using scrubber Y. Both X and Y must be held by the robot to apply
this action. If X is glassware, it can only be scrubbed with a brush. If X is a plate, it can only
be scrubbed with a sponge. If Y is soapy, then X will be soapy after it is scrubbed. If X is a dirty
dish, it will remain dirty after it is scrubbed (ie. the food stays on it until the dirt and soap
is rinsed off). Note that scrubbing a dish with a scrubber that has no soap on it will have no
effect on the dish.
/

poss(scrub(X, Y), S) :- holding(X, S), holding(Y, S), numHolding(2, S), dish(X), scrubber(Y), not (glassware(X), Y = sponge), not (plate(X), Y = brush).

/
• rinse(X): rinses item X. The faucet must be on and X must currently be held by the robot in
order to rinse it. If X is a scrubber that is soapy, it will no longer be soapy after rinsing it. If
X is a dish that is both soapy and dirty (ie. because it was scrubbed using a soapy scrubber),
then it will be clean and not soapy after being rinsed. In all cases, an item will be wet after
being rinsed.
/

poss(rinse(X), S) :- faucetOn(S), holding(X, S).


%%%%% SECTION: successor_state_axioms_dishwashing
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

/
• holding(X, S) holds if the robot is holding item X in S.
/

% the robot is holding item X if he previous action was to pick up item X, 
% or if one of the previous axtions was to pick up item X
holding(X, [pickup(X,P)|S]).
holding(X, [A|S]) :- not(A=putDown(X,P)), holding(X,S). 

/
• numHolding(C, S) holds if the robot is holding C different items in S. Since the robot has 2
hands, this is at most 2 items.

COME BACKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
/

% if the previous action was holding the item X then the robot is holding at least one item,
% if another previous action... im debating using holding or pickup... i think need to redo this with pickup when im better rested
numHolding(0, []).
numHolding(C, [holding(X)|S]) :- numHolding(C1, S), C is C1 + 1, not(C > 2).
numHolding(C, [A|S]) :- not(A=numHolding(C1, S)), C is C1 + 0, not(C > 2).

/
• faucetOn(S) holds if the faucet is on in S.
/

faucetOn([turnOnFaucet|S]).
faucetOn([A|S]) :- not(A=turnOffFaucet), faucetOn(S).

/
• loc(X, P, S) holds if the location of item X in situation S is P. Here, P is a place. If the robot
is holding X in S, then no such loc fluent will hold for X in S.
/

/
• wet(X, S) holds if the item X is wet in S.
/

wet(X, [rinse(X)|S]).
wet([A|S]) :- not(A=rinse(X)), wet(S).

/
• dirty(X, S) holds if the item X is dirty in S. Recall that scrubbers never get dirty.
/

dirty(X, S) :- not(scrubber(X)), not clean(X, S).

clean(X,[rinse(X), scrub(X,Y), addSoap(Y)|S]).
clean(X, [A|S]) :- not(A=rinse(X)), clean(S).

/
• soapy(X, S) holds if the scrubber X is soapy in S.
/

soapy(X, [addSoap(X)|S]) :- scrubber(X).
soapy([A|S]) :- not(A=addSoap(X)), soapy(S), scrubber(X).

%%%%% SECTION: declarative_heuristics_dishwashing
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
%%%%% write your rules implementing the predicate  useless(Action, History) here. %



