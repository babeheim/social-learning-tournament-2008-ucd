%1. Innovates on first 2 rounds, then plays the higher of the two. 
%2. Observes on the fourth round and plays the higher of the three. 
%3. After that, plays ML's experimenter strategy - i.e. plays the highest
%   thing in its repertoire, and innovates/observes each with a 10%
%   probability.
 

function [move, myRep]=choosy_experimenter2(roundsAlive, myRepertoire, myHistory)

if roundsAlive<2 %innovates twice

    move=-1;
    
elseif roundsAlive==2 
    if myRepertoire(1,2)>myRepertoire(2,2) %plays the better strategy
        move=myRepertoire(1,1);
    else
        move=myRepertoire(2,1);
    end
    
elseif roundsAlive==3 %observes on the 4th round
    move=0;   
    
else
    choice=median(myRepertoire(2, :));
    rankedR_Matrix = sortrows([myRepertoire'],2); %rank acts by payoffs
    best = rankedR_Matrix(size(rankedR_Matrix,1),2);
    choice=2*choice;
    choose=rand;
    if best < choice && choose < .1
        move=-1;
    elseif best < choice && choose < .2
        move=0;     
    else %exploit best payoff in repertoire 80 percent of time
      
        rankedR_Matrix = sortrows([myRepertoire'],2); %rank acts by payoffs
        move = rankedR_Matrix(size(rankedR_Matrix,1),1); %perform the act with best payoff
      
    end

    

end

 

myRep=myRepertoire;

 