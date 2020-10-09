
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Round 1 and 2: Innovate
%Round 3: Exploit
%Rounds 4 to End: Exploit unless payoff decreases below median payoff, then
%       switch
%
%Ryan Boyko with base of code by Matt Zimmerman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [move, myRep]=matt_strategy4(roundsAlive, myRepertoire, myHistory)

%roundsAlive

%myHistory


%myRepertoire

%%%% clear (0, 0) from repertoire--->prob delete before submitting
if (isempty(myRepertoire)==0) && (myRepertoire(1,1)==0)
    if size(myRepertoire,2)==1
        myRepertoire=[];
    else
        myRepertoire = myRepertoire(1:2,2:size(myRepertoire,2));
    end
end    

if roundsAlive==0
    move=0;
    
elseif (size(myRepertoire, 2)==1) && (size(myHistory,2) > 1) && (roundsAlive > 1) && (myHistory(3,1)~=0) %% This is for the case where there are two indentical observations: implying population is at a maximum
    if myHistory(4,size(myHistory,2)) < myHistory(4,size(myHistory,2)-1)
        move=-1;
    else
        move=myRepertoire(1,1);
    end
    
    %disp('Trig 1')
    
elseif size(myRepertoire,2)<2 && myHistory(3,1)==0
    move=-1; %INNOVATE
    %disp('Trig 2')
    
elseif size(myRepertoire, 2)<2  %%%if there are less than two moves in the repetoire observe, and you observed something in the first round, observe
    move=0; %OBSERVE

    %disp('Trig 3')
    
    
    
else
    
    %disp('Trig 4')
    
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

    %%%%%%%%%%%% end p_c estimate
    
    %%%% Estimate mean environmental payoff
    
    unique_sum=0;
    unique_counter=0;
    
    for aa=1:size(myRepertoire, 2)
        
        focal_move=myRepertoire(1,aa);
        
        move_samples=find(myHistory(2,:)==focal_move);
        
        if isempty(move_samples)==1
            unique_sum=unique_sum+myRepertoire(2,myRepertoire(1,:)==focal_move);
            unique_counter=unique_counter+1;
        else
        
            unique_sum=unique_sum+myHistory(4,move_samples(1,1));
            unique_counter=unique_counter+1;
        
            for bb=2:size(move_samples,2)
                if myHistory(4,move_samples(bb))~=myHistory(4,move_samples(bb-1));
                    unique_sum=unique_sum+myHistory(4,move_samples(bb));
                    unique_counter=unique_counter+1;
                end
            end
        end
        
    end
                
    est_mean_payoff=unique_sum/unique_counter;
    
    %%% End estimate of mean environmental payoff
    
    
    
    if (myHistory(3,size(myHistory,2))~=myHistory(3,size(myHistory,2)-1)) || (myHistory(4,size(myHistory,2))<myHistory(4,size(myHistory,2)-1))%%% You only need to pick a new action, if the payoff declines (or you just switched to a new action)
        for aa=1:size(myRepertoire,2) %for everything in the repetoir
        
            time_since_last(aa)=roundsAlive-myHistory(1,max(find(myHistory(3,:)==myRepertoire(1,aa)))); %#ok<AGROW,MXFND> %finds time since move was last played/observed
            magic_trigger(aa)=(myRepertoire(2,aa)-est_mean_payoff)*((1-est_env_change)^(time_since_last(aa))); %#ok<AGROW> %caculates the magic trigger
        
        end
        
        move=myRepertoire(1,magic_trigger==max(magic_trigger));
        exp_payoff=(1-est_env_change)*max(magic_trigger)+est_mean_payoff; 
        
        move=move(1);
        
    else %otherwise repeat the same action as last time
        move=myHistory(2,size(myHistory,2));
        exp_payoff=((myHistory(4,size(myHistory,2))-est_mean_payoff)*(1-est_env_change))+est_mean_payoff;
    end

    % decide if we should instead learn again
    if (roundsAlive > 7) && (exp_payoff < est_mean_payoff)
        if est_mean_payoff == 0
            move = 0;
        else
            choice=rand;
            test = .5*(exp_payoff/est_mean_payoff) + .5*(est_env_change/.4);
            
            if choice > test
                move = 0;
            end
        end
    end
    
end
   
%move

myRep=myRepertoire;