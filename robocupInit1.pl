%%%%% Do NOT copy this file into robocup.pl
%%%%% Feel free to make new initial states for testing/debugging purposes
%%%%% However, we suggest to do so, you should create a new file and load it 
%%%%% instead of this one in robocup.pl
%%%%% DO NOT SUBMIT THIS FILE

% This situation consists of a 3x4 grid with 3 robots an 3 opponents

numCols(3).
numRows(4).
goalCol(1).

opponentAt(1, 1).
opponentAt(2, 0).
opponentAt(2, 1).

robot(r1).
robot(r2).
robot(r3).

hasBall(r1, []).
robotLoc(r1, 1, 0, []).
robotLoc(r2, 0, 2, []).
robotLoc(r3, 3, 1, [])


