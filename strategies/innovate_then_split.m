
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Round 1: Innovate
%Round 2: Exploit
%Rounds 3 to End: Observe-half the-time, Exploit half-the-time (always exploits from first round)
%
%Matt Zimmerman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This strategy accepts roundsAlive, myRepertoire and myHistory as inputs,
% and delievers move and myRep as outputs...

function [move, myRep]=innovate_then_split(roundsAlive, myRepertoire, myHistory) 

%fundamentally, the function must do two things: 
%1. pick a move (-1 (innovate), 0 (observe), or something  from its
%repertoire (execute) based on its analysis of the situation
%2. return a myRep value?

if roundsAlive==0 %its first round of life, it innovates
    move=-1;
elseif roundsAlive==1  %on the second round, it does the same as its first round?
    move=myRepertoire(1,1);
elseif rand < .5 %half the time it observes
    move=0;
else
    move=myRepertoire(1,1); %and half the time it does the thing it innovated first round
end
    
myRep=myRepertoire;

