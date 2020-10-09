% 1. Innovate
% 2. Exploit what you innovated
% 3. Play best move.  If it goes below myMeanPayoff, observe.  

function [move, myRepertoire] = cwpd(roundsAlive, myRepertoire, myHistory) 

if roundsAlive>1; %if this isn’t my first (roundsAlive=0) or second (roundsAlive=1) round 
    myMeanPayoff = mean(myHistory(4,(myHistory(2,:)>0))); %mean payoff from EXPLOIT 
    lastExploit = find((myHistory(2,:)>0),1,'last'); %find last EXPLOIT 
    lastPayoff = myHistory(4,lastExploit); %get the payoff from last EXPLOIT 
    lastMove = myHistory(2,find((myHistory(1,:)==roundsAlive-1),1,'first')); %find last move  
    
    if (lastMove==0) || (lastPayoff>=myMeanPayoff) 
        %if lastMove was observe or lastPayoff at least as good as myMeanPayoff then EXPLOIT 
        rankedR_Matrix = sortrows(myRepertoire',-2); %rank acts by payoffs 
        move = rankedR_Matrix(1,1); %perform the act with best payoff  
    else %if last move was below myMeanPayoff and I didn't just observe,
        move = 0; %OBSERVE 
    end

elseif roundsAlive>0; %if this is my second (roundsAlive=1) round…

    move = myRepertoire(1,1); %only have one behaviour from INNOVATE, so use that 

else %if this is my first round (roundsAlive=0)

    move = -1; %INNOVATE

end 