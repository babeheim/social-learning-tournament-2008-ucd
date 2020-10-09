
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

%%%% Section I - Environmental Parameter Estimation
    est_env_change=.001; % estimate of environmental change

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
  
    
% Section I Output:
    
    %M = avg
    M = med_payoff;
    
   
%%% Section II - First Two Moves 
%if (isempty(myRepertoire)==0) && (myRepertoire(1,1)==0)
if roundsAlive == 2;
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
elseif roundsAlive == 4 %if last move was an innovate / exploit
    orderedRep = sortrows([myRepertoire'],2);
    move=orderedRep(size(orderedRep,1),1);
    
%%% Section III - The Remaining Moves


% Analytic Trigger Setup

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
      
% The Analytic Trigger Equation
    if (cur_payoff-M)>((alt_payoff-M)*(s^(n-1)))
        move=cur_move;      
    else
        move=alt_move;
    end
end

  
           
myRep=myRepertoire;