

%The basic idea is that it innovates on Round 1, then just exploits most of the time with some 
%random observe and innovate over time. There is no tracking of mean payoffs, aspiration levels etc.  
% It should look like our lab subjects—they stick with a payoff, and then randomly look around…
%
 

function [move, myRep]=experimenter(roundsAlive, myRepertoire, myHistory)

 

if roundsAlive==0

    move=-1;

else

    choice=rand;

    if choice <.2 %innovate 10 percent of time

        move=-1;
                
    elseif choice < .3
        
        move=0;
        
    else %exploit best payoff in repertoire 80 percent of time
      
        rankedR_Matrix = sortrows(myRepertoire',-2); %rank acts by payoffs
        move = rankedR_Matrix(1,1); %perform the act with best payoff
      
    end

end

 

myRep=myRepertoire;

 