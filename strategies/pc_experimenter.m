
function [move, myRep]=pc_experimenter(roundsAlive, myRepertoire, myHistory)


%%%%%%%%%%%%%%%%%Estimate Env Change


env_change_counter=0;
repeat_move_counter=0;

for a=1:roundsAlive-1
    if (myHistory(2,a)==-1 || myHistory(2,a)>0) && myHistory(3,a)==myHistory(3,a+1)
        repeat_move_counter=repeat_move_counter+1;
        if myHistory(4,a)~=myHistory(4,a+1)
            env_change_counter=env_change_counter+1;
        end
    end
end

if repeat_move_counter~=0
    est_env_change=env_change_counter/repeat_move_counter;
else
    est_env_change=.2;
end

%%%%%%%%%%%%%%%%%End Estimate of Env Change




if est_env_change < 0.1 % Low environmental change - play experimenter_0_2
    
    if roundsAlive==0

        move=-1;

    else

        choice=rand;
    
        if choice < .2 %Medium environmental change - play experimenter_0_1
        
            move=0;

        else %exploit best payoff in repertoire 80 percent of time
        
            rankedR_Matrix = sortrows([myRepertoire'],2); %rank acts by payoffs
        
            move = rankedR_Matrix(size(rankedR_Matrix,1),1); %perform the act with best payoff
    
        end

    end
    
    
    
elseif est_env_change < 0.3
    
    if roundsAlive==0

        move=-1;

    else

        choice=rand;
    
        if choice < .1 %innovate 10 percent of time
        
            move=0;

        else %exploit best payoff in repertoire 80 percent of time
        
            rankedR_Matrix = sortrows([myRepertoire'],2); %rank acts by payoffs
        
            move = rankedR_Matrix(size(rankedR_Matrix,1),1); %perform the act with best payoff
    
        end

    end


else %variable environment - play experimenter_1_0
        
    if roundsAlive==0

        move=-1;

    else

        choice=rand;
    
        if choice < .1 %innovate 10 percent of time
        
            move=-1;

        else %exploit best payoff in repertoire 80 percent of time
        
            rankedR_Matrix = sortrows([myRepertoire'],2); %rank acts by payoffs
        
            move = rankedR_Matrix(size(rankedR_Matrix,1),1); %perform the act with best payoff
    
        end

    end



end

 

myRep=myRepertoire;

 