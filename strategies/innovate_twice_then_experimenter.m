%Innovates on first 2 rounds, then plays the higher of the two. Observes on
%the fourth round and plays the higher of the three. After that, plays
%experimenter
 

function [move, myRep]=social_start_then_choosy(roundsAlive, myRepertoire, myHistory)

if (isempty(myRepertoire)==0) && (myRepertoire(1,1)==0)
    if size(myRepertoire,2)==1
        myRepertoire=[];
    else
        myRepertoire = myRepertoire(1:2,2:size(myRepertoire,2));
    end
end

if size(myRepertoire, 2)<2
    if size(myRepertoire, 2)==1 && roundsAlive<3 && myHistory(2,1) == -1
        move=myRepertoire(1,1);
    else
        choice=rand;
        if roundsAlive==0 && choice <.1 %innovate 10 percent of time
            move=-1;
        else
            move=0;
        end
    end
elseif myHistory(2,size(myHistory,2))<1
    orderedRep = sortrows([myRepertoire'],2);
    move=orderedRep(size(orderedRep,1),1);
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

 