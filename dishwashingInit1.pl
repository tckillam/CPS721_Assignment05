%%%%% Do NOT copy this file into dishwashing.pl
%%%%% Feel free to make new initial states for testing/debugging purposes
%%%%% However, we suggest to do so, you should create a new file and load it 
%%%%% instead of this one in dishwashing.pl
%%%%% DO NOT SUBMIT THIS FILE

% The initial situation consists of a single dirty glass on
% the counter, with the brush on the counter and the sponge
% in the dish rack. The faucet is not on

numHolding(0, []).

glassware(g1).

loc(g1, counter, []).

dirty(g1, []).

loc(brush, counter, []).
loc(sponge, dish_rack, []).

