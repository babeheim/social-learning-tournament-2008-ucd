 
function [move, myRepertoire] = iwpd(roundsAlive, myRepertoire, myHistory) 

if roundsAlive>1; %if this isn’t my first or second round… 
    myMeanPayoff = mean(myHistory(4,(myHistory(2,:)>0))); %mean payoff from EXPLOIT 
    lastExploit = find((myHistory(2,:)>0),1,'last'); %find last EXPLOIT 
    lastPayoff = myHistory(4,lastExploit); %get the payoff from last EXPLOIT 
    lastMove = myHistory(2,find((myHistory(1,:)==roundsAlive-1),1,'first')); %find last move  
if (lastMove==-1) || (lastPayoff>=myMeanPayoff) %if lastMove was observe or lastPayoff at least as good as myMeanPayoff then EXPLOIT 
    rankedR_Matrix = sortrows([myRepertoire'],-2); %rank acts by payoffs 
    move = rankedR_Matrix(1,1); %perform the act with best payoff  
else %otherwise 
    move = -1; %OBSERVE 
end
elseif roundsAlive>0; %if this is my second round…
    move = myRepertoire(1,1); %only have one behaviour from INNOVATE, so use that 
else
    move = -1; %if this is my first round, then INNOVATE
end 