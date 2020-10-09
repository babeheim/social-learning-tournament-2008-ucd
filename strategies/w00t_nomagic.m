
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% w00t!
%
% Strategy for the 2008 Social Learning Strategies Tournament
%
% Round 1: Observe
% Round 2: Observe a 2nd action, innovate if nothing was observed, exploit
% if >= 2 things were observed (whether or not they were the same)
% Round 3: Exploit or innovate if nothing was observed in the first round
% Subsequently exploit the action with the highest expected payoff in your
%    repertoire unless it is particularly bad in which case you learn again
%   (probabilistic trigger) or if you only have one action in your
%   repertoire and its payoff declines in which case you innovate
%
% Matt Zimmerman, Ryan Boyko, Paul Smaldino, Bret Beheim, Adrian Bell and Corin Boyko
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [move, myRep]=w00t(roundsAlive, myRepertoire, myHistory)

%%%% clear (0, 0) from repertoire--->this is probably just an artifact from
%%%% our tournament simulation code, but does not harm under the
%%%% tournament's rules either, but it isn't really part of our strategy
%%%% either
if (isempty(myRepertoire)==0) && (myRepertoire(1,1)==0) %if the rep is not empty, but the first move is 0
    if size(myRepertoire,2)==1 %if there's only one strat in the rep
        myRepertoire=[]; %flush the rep
    else
        myRepertoire = myRepertoire(1:2,2:size(myRepertoire,2)); %if its not the first, flush the rep
    end
end  
% Bret: but does this account for myRepertoire(1,x)..where x is not 1?

%%% DETERMINE THE ACTION TO TAKE

% observe on the first round
if roundsAlive==0
    move=0; 

% This is for the case where there are two identical observations, implying population is at a maximum 
% Three things must be true: there's only one move in the rep, there's more
% than one move in the history, and the first move in the history was
% observe (BRET: why does the first move need to be observe?)
elseif (size(myRepertoire, 2)==1) && (size(myHistory,2) > 1) && (myHistory(3,1)~=0)
    
    % Innovate to learn a second action when the payoff for the one known
    % action decreases (or when it is less than or equal to 0).
    if (myHistory(4,size(myHistory,2)) < myHistory(4,size(myHistory,2)-1)) || (myHistory(4,size(myHistory,2)) <= 0)
        move=-1;
    else
        move=myRepertoire(1,1);    % Otherwise, exploit the known action
    end
    
% If you did not observe any actions in the first round, innovate twice because you're probably at the start of the game    
elseif size(myRepertoire,2)<2 && myHistory(3,1)==0
    move=-1; %INNOVATE
    
% if there are less than two moves in the repetoire, and you observed something in the first round, observe    
elseif size(myRepertoire, 2)<2
    move=0; %OBSERVE   
    
% when there are two or more actions in the repertoire, play the strategy below    
else
    % first have to estimate how frequently actions' payoffs change and the
    % mean payoff in the payoff distribution for the tournament
    
    %%%%%%%%%%%% estimate p_c, the probability an action's payoff changes
    %%%%%%%%%%%% on any given round
    env_change_counter=0;
    repeat_move_counter=0;

    for a=1:roundsAlive-1
        if (myHistory(2,a)==-1 || myHistory(2,a)>0) && (myHistory(3,a)==myHistory(3,a+1)) %if you innovated or exploited, and your move is less than
            repeat_move_counter=repeat_move_counter+1;  % count how many times you saw the payoff for a given action in two consecutive rounds (exclude observational learning since it's error-prone)
            if myHistory(4,a)~=myHistory(4,a+1)
                env_change_counter=env_change_counter+1;   % count how many of those times the payoff changed
            end
        end
    end

    % calculate the p_c estimate, the estimate of the probability an
    % action's payoff changes in any given round, using the values derived
    % above
    if repeat_move_counter~=0
        est_env_change=env_change_counter/repeat_move_counter;   % divide the number of payoff changes seen by the number of consecutive times you exploited/innovated the same action
    else
        est_env_change=.2;   % if there's no evidence, just assume it's .2
    end

    % truncate extreme estimates to the minimum and maximum possible in the
    % tournament (.001 to .4)
    if est_env_change < .001
        est_env_change=.001;
    elseif est_env_change > .4
        est_env_change=.4;
    end

    %%%%%%%%%%%% end p_c estimate
    
    
    %%%% Estimate mean environmental payoff
    
    % To do so requires counting each independent observation which means
    % going over the history of each action to account for cases when the
    % payoff changes from one value to another and then back again to
    % include all the independent observations. This still undercounts
    % common values since it does not count cases when the payoff changes
    % from one value to the same value, but this is not possible to
    % overcome given the way the tournament is setup.
    
    unique_sum=0;
    unique_counter=0;
    
    for aa=1:size(myRepertoire, 2)   % go over all the moves in the repertoire
        
        focal_move=myRepertoire(1,aa);
        
        move_samples=find(myHistory(2,:)==focal_move);  % find each time you exploited that action
        
        % if you've never exploited the action, just count the one time you
        % observed or innovated the action as one independent value
        if isempty(move_samples)==1
            unique_sum=unique_sum+myRepertoire(2,myRepertoire(1,:)==focal_move);
            unique_counter=unique_counter+1;
        else
        
            % otherwise, if you have exploited that action, count the first
            % time you exploited it as one independent value
            unique_sum=unique_sum+myHistory(4,move_samples(1,1));
            unique_counter=unique_counter+1;
        
            % each subsequent time you exploited the action, count the
            % value as an independent value if and only if it is different
            % from the previous time it was exploited; otherwise, discard
            % the value as probably not independent.
            for bb=2:size(move_samples,2)
                if myHistory(4,move_samples(bb))~=myHistory(4,move_samples(bb-1));
                    unique_sum=unique_sum+myHistory(4,move_samples(bb));
                    unique_counter=unique_counter+1;
                end
            end
        end
        
    end
                
    % calculate the estimated mean payoff using the values derived above
    est_mean_payoff=unique_sum/unique_counter;
    
    %%% End estimate of mean environmental payoff
    
    
    
    if (myHistory(3,size(myHistory,2))~=myHistory(3,size(myHistory,2)-1)) || (myHistory(4,size(myHistory,2))<myHistory(4,size(myHistory,2)-1))   % You only need to pick a new action, if the payoff declines (or you just switched to a new action)
        for aa=1:size(myRepertoire,2) % for everything in the repertoire, determine the expected payoff using the payoff you last saw it at, how many turns ago that was, how quickly payoffs change and the mean payoff in the environment
        
            time_since_last(aa)=roundsAlive-myHistory(1,max(find(myHistory(3,:)==myRepertoire(1,aa)))); % finds time since move was last played/observed
            magic_trigger(aa)=myRepertoire(2,aa); % caculates using payoff
            
        end
        
        % find the action with the best "magic trigger" (highest expected
        % value) and save what that expected value is to use later in the
        % "Plan C" if statement and trigger
        move=myRepertoire(1,magic_trigger==max(magic_trigger));
        exp_payoff=(1-est_env_change)*max(magic_trigger)+est_mean_payoff; 
        
        move=move(1);   % save the action with the best expected value as the move
        
    else % otherwise, if the payoff for it hasn't changed, repeat the same action as last time
        move=myHistory(2,size(myHistory,2));
        exp_payoff=((myHistory(4,size(myHistory,2))-est_mean_payoff)*(1-est_env_change))+est_mean_payoff;
    end

    % "Plan C"---decide if we should instead learn again
    if (roundsAlive > 7) && (exp_payoff < est_mean_payoff)   % only learn when you're getting a worse payoff than the mean payoff seen and when there's been enough time for a decent p_c estimate
        if est_mean_payoff <= 0   % always learn when the best payoff in your repertoire is 0 or below 0; very little opportunity cost
            move = 0;
        else
            % otherwise, use the below equation based on the expected payoff of the action you would exploit, the mean payoff in the environment and the probability of payoff changes per round to determine the probability you should again learn (probabilistic trigger since an analytical solution is impossible without knowing the actual payoff distribution)
            if rand > .5*(exp_payoff/est_mean_payoff) + .5*(est_env_change/.4)
                move = 0;
            end
        end
    end
    
end

%%% END OF DETERMINING ACTION TO TAKE

% return the repertoire unchanged
myRep=myRepertoire;