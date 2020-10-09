
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Round 1 and 2: Innovate
%Round 3: Exploit
%Rounds 4 to End: Exploit unless payoff decreases below median payoff, then
%       switch
%
%Ryan Boyko with base of code by Matt Zimmerman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [move, myRep]=woot_observe_s_good(roundsAlive, myRepertoire, myHistory)
% 
% env_change_counter=0;
% repeat_move_counter=0;

% for a=1:roundsAlive-1
%    if (myHistory(2,a)==-1 || myHistory(2,a)>0) && (myHistory(3,a)==myHistory(3,a+1))
%         repeat_move_counter=repeat_move_counter+1;
%         if myHistory(4,a)~=myHistory(4,a+1)
%            env_change_counter=env_change_counter+1;
%        end
%    end
% end

% if repeat_move_counter~=0
%    est_env_change=env_change_counter/repeat_move_counter;
% else
   est_env_change=.1;
% end     

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
        if choice <.1 %innovate 10 percent of time
            move=-1;
        else
            move=0;
        end
    end
elseif myHistory(2,size(myHistory,2))<1
    orderedRep = sortrows([myRepertoire'],2);
    move=orderedRep(size(orderedRep,1),1);
else 
    cur_move=myHistory(3,size(myHistory,2));
    cur_payoff=myHistory(4,size(myHistory,2));
    
    if cur_move == myRepertoire(1,1) %if it was the first move learned
       alt_move = myRepertoire(1,2); %the second move learned is alt
       alt_payoff = myRepertoire(2,2);
    else 
       alt_move = myRepertoire(1,1); %or the opposite
       alt_payoff = myRepertoire(2,1);
    end
     
    s=1-est_env_change;
    ind=size(myHistory,2)-1;
    while myHistory(3,ind) ~= alt_move
        ind=ind-1;
    end
    n=size(myHistory,2)-(ind-1);
        
    %Mean Est
    avg=mean(myHistory(4,:));
    
    %Median Est
    payoffs = myHistory(4,1:size(myHistory, 2));
    ordered_payoffs = sortrows([payoffs]');
 %   ordered_payoffs
    if mod(size(ordered_payoffs),2)==0
        med_payoff = (ordered_payoffs(size(ordered_payoffs)/2)+ordered_payoffs(size(ordered_payoffs)/2+1))/2;
    else
        med_payoff = ordered_payoffs(ceil(size(ordered_payoffs)/2));
    end
    
    %M = avg
    M = med_payoff;
    
    %The Analytic Trigger
    if (cur_payoff-M)>((alt_payoff-M)*(s^(n-1)))
        move=cur_move;      
    else
        move=alt_move;
    end
end

    %myHistory = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18;0,0,11,5,11,11,11,11,11,11,11,11,11,11,11,11,11,11;11,5,11,5,11,11,11,11,11,11,11,11,11,11,11,11,11,11;14,8,8,0,8,8,8,8,8,8,8,8,8,8,8,8,1,1;]
     
           
myRep=myRepertoire;