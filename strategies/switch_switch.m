
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Round 1: Innovate
%Round 2: Exploit what you innovated
%Rounds 3 to End: Observe-half the-time, Exploit half-the-time (always exploits from first round)
%
% NOTE - doesn't do what it is supposed to, but throwaway strat anyway
%
%Matt Zimmerman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [move, myRep]=innovate_then_split(roundsAlive, myRepertoire, myHistory)

if roundsAlive==0
    move=-1;
elseif roundsAlive==1
    move=myRepertoire(1,1);
elseif myHistory(4,roundsAlive)>=myHistory(4,roundsAlive-1) %if the payoff from the last move, 
    move=myHistory(3,roundsAlive);
else
    if myHistory(3,roundsAlive)~=-1
        move=-1;
    else 
        move=myHistory(3,roundsAlive-1);
    end
end
    

    
myRep=myRepertoire;

