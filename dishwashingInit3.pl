%%%%% Do NOT copy this file into dishwashing.pl
%%%%% Feel free to make new initial states for testing/debugging purposes
%%%%% However, we suggest to do so, you should create a new file and load it 
%%%%% instead of this one in dishwashing.pl
%%%%% DO NOT SUBMIT THIS FILE

% The initial situation consists of the robot holding the
% a dirty glass and a soapy brush. There is also a dirty
% plate on the counter. The faucet is on.

numHolding(2, []).

plate(p1).
glassware(g1).

loc(p1, counter, []).

dirty(p1, []).
dirty(g1, []).

holding(brush, []).
holding(g1, []).

soapy(brush, []).
loc(sponge, dish_rack, []).

faucetOn([]).

