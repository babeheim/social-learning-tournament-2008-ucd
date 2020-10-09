 
function [move, myRepertoire] = cwpd_v6(roundsAlive, myRepertoire, myHistory) 

if roundsAlive>1; %if this isn’t my first or second round… 
    
    myMeanPayoff = mean(myHistory(4,(myHistory(2,:)>0))); %mean payoff from EXPLOIT 
    
    for x=1:roundsAlive
        if myHistory(2,x) > 0
            lastExploit=myHistory(1,x);
        end
    end
    
    lastPayoff = myHistory(4,lastExploit); %get the payoff from last EXPLOIT 
    lastMove = myHistory(2,roundsAlive); %find last move  
    
    if (lastMove==0) || (lastPayoff>=myMeanPayoff) %if lastMove was observe or lastPayoff at least as good as myMeanPayoff then EXPLOIT 
        
        rankedR_Matrix = sortrows(myRepertoire',-2); %rank acts by payoffs 
        
        move = rankedR_Matrix(1,1); %perform the act with best payoff  
    else %otherwise 
        move = 0; %OBSERVE 
    end

elseif roundsAlive>0; %if this is my second round, use the behavior I just learned

    move = myRepertoire(1,1); 

else

    move = -1; %if this is my first round, then INNOVATE

end 