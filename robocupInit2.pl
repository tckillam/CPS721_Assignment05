%%%%% Do NOT copy this file into robocup.pl
%%%%% Feel free to make new initial states for testing/debugging purposes
%%%%% However, we suggest to do so, you should create a new file and load it 
%%%%% instead of this one in robocup.pl
%%%%% DO NOT SUBMIT THIS FILE

% This situation consists of a 5x5 grid seen in Figure 1 of the assignment PDF

numCols(5).
numRows(5).
goalCol(2).

opponentAt(1, 2).
opponentAt(2, 0).
opponentAt(2, 1).
opponentAt(2, 3).
opponentAt(4, 3).

robot(r1).
robot(r2).
robot(r3).
robot(r4).
robot(r5).

hasBall(r1, []).
robotLoc(r1, 0, 2, []).
robotLoc(r2, 0, 3, []).
robotLoc(r3, 0, 4, []).
robotLoc(r4, 1, 1, []).
robotLoc(r5, 3, 2, []).

