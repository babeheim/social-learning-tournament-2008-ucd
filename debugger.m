clear;
clc;

strategy=@switch_switch; % name the strategy you want to test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Strategy Debugger, v. 0.01                      %
% by Bret Alexander Beheim,                       %
% with help from Ryan and Matt                    %
%                                                 %
% Tests one agent for one lifespan, black-boxing  %
% the source of the learning for testing purposes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

roundsAlive=0;
p_c = 0.4;              %the rate of environmental change
myRepertoire=zeros(2,1);
myHistory=zeros(4,1);   %creates myHistroy and myRepertoire
environment_size=100;   %size of environment/number of different actions
environment=ceil(abs(10*randn(1,environment_size))); %nearly same distribution as Matt's...I used ceil to fix a bug
strategy_str=func2str(strategy); %captures the strat name to put in output

for roundsAlive = 0:50  %this manually determines how long the organism will live, in this case 50 rounds

    clc;   
    
    [move,myRep]=feval(strategy, roundsAlive, myRepertoire, myHistory); %calls the strat specified up at top
    roundsAlive = roundsAlive+1;  %the sands of the hourglass
    
    disp(sprintf('\n %s chooses %d \n', strategy_str, move)); 
    %disp(sprintf('%s', move));  %this prints what the strategy chose - innovate, observe or exploit

    if move==0 || move==-1 %my simple substitute for social learning or innovation
        new_action = ceil(abs(10*randn)); %pick random number between 1 an 100
        new_payoff = environment(new_action); %take the associated payoff in environment
           
    elseif move > 0
        new_action=move;
        new_payoff=environment(new_action);
    end
           
        
if roundsAlive==1;
    myHistory = [roundsAlive; move; new_action; new_payoff];
    myRepertoire = [new_action; new_payoff];
    
else
    myHistory = [myHistory [roundsAlive; move; new_action; new_payoff]];
    
    ind1 = 1;
    ind2 = 1;
    while ind1 <= size(myRepertoire,2) && myRepertoire(1,ind1)~= new_action,
        ind1=ind1+1;
    end

    if ind1 > size(myRepertoire,2) %can only happen if new action isn't in rep yet
      myRepertoire = [myRepertoire [new_action; new_payoff]];
    else %action is already known...now to need to update payoff in rep
      for ind2 = 1:size(myRepertoire,2)
         if myRepertoire(1,ind2) == new_action
            myRepertoire(2,ind2) = new_payoff;
         end
      end
        
    end

    
    
end

%Environment Changes
        for e=1:environment_size
            if rand < p_c
                environment(e)=floor(abs(10*randn));
            end
        end


        
myRepertoire %prints both
myHistory

%%%%%%%%%%%%
%Output Statistics (feel free to add here)

%Average Payoff
actual_avg = mean(environment);
total_avg = mean(myHistory(4,:));
unique_avg = mean(unique(myHistory(4,:)));


if roundsAlive == 1
    total_avg_tracker_storage = round(total_avg/actual_avg*100);
    total_avg_tracker = total_avg_tracker_storage;
    unique_avg_tracker_storage = round(unique_avg/actual_avg*100);
    unique_avg_tracker = unique_avg_tracker_storage;
elseif roundsAlive > 1
    total_avg_tracker_storage = [total_avg_tracker_storage [round(total_avg/actual_avg*100)]];
    total_avg_tracker = round(mean(total_avg_tracker_storage));
    unique_avg_tracker_storage = [unique_avg_tracker_storage [round(unique_avg/actual_avg*100)]];
    unique_avg_tracker = round(mean(unique_avg_tracker_storage));
end



% % Mean Payoff
% if sum(myHistory(4,(myHistory(2,:)>0)))>0
% myMeanPayoff = (sum(myHistory(4,(myHistory(2,:)>0)))/roundsAlive); %mean payoff from EXPLOIT 
% else myMeanPayoff = 0;
% end
% disp(sprintf('mean_payoff = %g',myMeanPayoff));

disp(sprintf('true mean = %g',actual_avg));
disp(sprintf('total est mean (tracker)= %g (%g%%)', total_avg, total_avg_tracker));  
disp(sprintf('unique est mean (tracker) = %g (%g%%)', unique_avg, unique_avg_tracker));


%Median Payoff
payoffs = myHistory(4,1:size(myHistory, 2));
ordered_payoffs = sortrows(payoffs');
if mod(size(ordered_payoffs),2)==0
     med_payoff1 = (ordered_payoffs(size(ordered_payoffs)/2)+ordered_payoffs(size(ordered_payoffs)/2+1))/2;
     median = med_payoff1(1);
   %  disp(sprintf('median payoff = %d (%g%%)', median, round(median/actual_avg*100))); 
else
     med_payoff1 = ordered_payoffs(ceil(size(ordered_payoffs)/2));
     median = med_payoff1(1);
   %  disp(sprintf('median payoff = %d (%g%%)', median, round(median/actual_avg*100))); 
end

%Unique Median
ordered_payoffs_unique = sortrows((unique(payoffs)'));
if mod(size(ordered_payoffs_unique),2)==0
     med_payoff2 = (ordered_payoffs_unique(size(ordered_payoffs_unique)/2)+ordered_payoffs_unique(size(ordered_payoffs_unique)/2+1))/2;
     median = med_payoff2(1);
   %  disp(sprintf('unique median payoff = %d (%g%%)', median, round(median/actual_avg*100))); 
else
     med_payoff2 = ordered_payoffs_unique(ceil(size(ordered_payoffs_unique)/2));
     median = med_payoff2(1);
   %  disp(sprintf('unique median payoff = %d (%g%%)', median, round(median/actual_avg*100))); 
end
    
pause

end

