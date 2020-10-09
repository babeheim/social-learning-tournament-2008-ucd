%stdevTrigger (median+1.0stdev)

function [move, myRepertoire] = stdDevTrigger(roundsAlive, myRepertoire, myHistory) 

if roundsAlive>1; %if this isn’t my first or second round… 
    medianPayoffs = median(myRepertoire(2,:)); %median payoffs from Repertoire
    stdPayoff=std(myRepertoire(2,:)); %Std payoff from Repertoire
    lastPayoff=myHistory(4,roundsAlive);
    
    if lastPayoff > medianPayoffs+1.0*stdPayoff %if lastPayoff at least as good as a stdv above medianPayoff then EXPLOIT 
        move=myHistory(3,roundsAlive);
    else %otherwise 
        if rand < 0.5
            move = -1; % 50% of the time innovate
        else
            move = 0; % 50% otherwise observe
        end
    end

elseif roundsAlive>0; %if this is my second round…
    if rand < 0.5
        move = myRepertoire(1,1); % half the time exploit
    else
        move = -1; %half the time innovate
    end

else
    move = -1; %if this is my first round, then INNOVATE
end 