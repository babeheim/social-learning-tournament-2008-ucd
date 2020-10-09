
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Round 1 and 2: Innovate
%Round 3: Exploit
%Rounds 4 to End: Exploit unless payoff decreases below median payoff, then
%       switch
%
%Ryan Boyko with base of code by Matt Zimmerman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [move, myRep]=woot_matt(roundsAlive, myRepertoire, myHistory)


if (isempty(myRepertoire)==0) && (myRepertoire(1,1)==0)
    if size(myRepertoire,2)==1
        myRepertoire=[];
    else
        myRepertoire = myRepertoire(1:2,2:size(myRepertoire,2));
    end
end


%%%%%%%%%%%% estimate p_c
env_change_counter=0;
repeat_move_counter=0;
for a=1:roundsAlive-1
   if (myHistory(2,a)==-1 || myHistory(2,a)>0) && (myHistory(3,a)==myHistory(3,a+1))
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

if est_env_change < .001
    est_env_change=.001;
elseif est_env_change > .4
    est_env_change=.4;
end

%est_env_change=prob_of_env_change;

%%%%%%%%%%%% end p_c estimate



if size(myRepertoire, 2)<2   %%%if there are less than two moves in the repetoire learn another move
    if size(myRepertoire, 2)==1 && roundsAlive<3 && myHistory(2,1) == -1
        move=myRepertoire(1,1);
    else
        choice=rand;
        if choice <.1 %innovate 10 percent of time
            move=-1;
        else
            move=0;
        end
    end

elseif myHistory(2,size(myHistory,2))<1
    orderedRep = sortrows([myRepertoire'],2);
    move=orderedRep(size(orderedRep,1),1);
    
else %choose a move based on the highest magic trigger.  In a tie, pick the most recent action.
    
    
    
    
    %%%% Estimate M
    
    unique_sum=0;
    unique_counter=0;
    
    for aa=1:size(myRepertoire, 2)
        
        focal_move=myRepertoire(1,aa);
        
        move_samples=find(myHistory(2,:)==focal_move);
        
        if isempty(move_samples)==1  %use the observed value if you haven't exploited yet
            unique_sum=unique_sum+myRepertoire(2,myRepertoire(1,:)==focal_move);
            unique_counter=unique_counter+1;
        else %only use the payoffs from exploit
        
            unique_sum=unique_sum+myHistory(4,move_samples(1,1));  %use the first payoff from exploit
            unique_counter=unique_counter+1;
        
            for bb=2:size(move_samples,2)   %use any additional payoff that isn't a repeat of the previous payoff for the action
                if myHistory(4,move_samples(bb))~=myHistory(4,move_samples(bb-1));
                    unique_sum=unique_sum+myHistory(4,move_samples(bb));
                    unique_counter=unique_counter+1;
                end
            end
        end
        
    end
                
    est_mean_payoff=unique_sum/unique_counter;  %divide the sum of the payoffs used by the number of payoffs used.
    
    
    %%% End M estimate
    
    
    
    for aa=1:size(myRepertoire,2) %for everything in the repetoir
        
        time_since_last(aa)=roundsAlive-myHistory(1,max(find(myHistory(3,:)==myRepertoire(1,aa)))); %#ok<AGROW,MXFND> %finds time since move was last played/observed
        magic_trigger(aa)=(myRepertoire(2,aa)-est_mean_payoff)*((1-est_env_change)^(time_since_last(aa))); %#ok<AGROW> %caculates the magic trigger
        
    end

    %roundsAlive
    %myHistory
    %myRepertoire

    %myRepertoire
    %myHistory
    %est_env_change
    %est_mean_payoff
    %time_since_last
    
    
    
    %time_since_last
    %magic_trigger
       
    move=myRepertoire(1,magic_trigger==max(magic_trigger));
    
    
    move=move(1);
    
    
    %move=myRepertoire(1,find(time_since_last(1,find(magic_trigger==max(magic_trigger)))==min(time_since_last(1,find(magic_trigger==max(magic_trigger)))))) %#ok<FNDSB> chooses highest magic trigger, and if a tie, plays the most recent
    
    %move=move(1)
    

    
end
    

myRep=myRepertoire;