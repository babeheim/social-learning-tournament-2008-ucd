

%%%%This version of the tournament is a function with inputs of the two
%%%%strategies, probability of environmental change; probablity of
%%%%observing the wrong action and the standard deviation of the
%%%%observation error

function [mean_final_strat1_pop, overall_winner]=rr_tournament_9(prob_of_env_change, prob_observed_wrong_act, observe_error_stdv, strategy1, strategy2)

strategy1_str=func2str(strategy1);
strategy2_str=func2str(strategy2);


disp(sprintf('\n %s vs. %s \n', strategy1_str, strategy2_str));
disp(sprintf('Prob Env Change \t Prob Obs Wrong \t Obs Error Stdv'));
disp(sprintf('%0.3f  \t \t \t \t %0.2f \t \t \t \t %0.2f \t \t \t \t %0.2f \t \t \t %s', prob_of_env_change, prob_observed_wrong_act,observe_error_stdv));
disp(sprintf('\t \t \t \t %s \t \t \t | \t \t %s', strategy1_str, strategy2_str));
disp(sprintf('Sim# \t # Inn \t # Obs \t # Exp \t Pop \t | \t # Inn \t # Obs \t # Exp \t Pop \t | Winner'));

%%%These parameters are defined in the tournament rules:

population_size=100;    %populations size
number_of_rounds=10000;  %number of rounds
environment_size=100;   %size of environment/number of different actions
death_rate=0.02;        %rate of death (individuals/round)
mutation_rate=0.02;     %rate of mutation (mutants/birth)
settlement_time=100;    %number of rounds invaded strategy has to settle before invastion starts

%%%%Parameters used to run many simulations to find ultimate winner
number_of_simulations=5;                              %total number of simulations run between two strategies for each invasion situation
final_population_range=round(number_of_rounds/4);      %The number of rounds used to calculate the winning population

%%%Tracking vectors for each simulation that are outputs at the end
final_strat1_pop_tracker=zeros(1,2*number_of_simulations);
strat1_innovate_tracker=zeros(1,2*number_of_simulations);
strat1_observe_tracker=zeros(1,2*number_of_simulations);
strat1_exploit_tracker=zeros(1,2*number_of_simulations);
strat2_innovate_tracker=zeros(1,2*number_of_simulations);
strat2_observe_tracker=zeros(1,2*number_of_simulations);
strat2_exploit_tracker=zeros(1,2*number_of_simulations);



for s=1:2*number_of_simulations
    
    %disp(s) %displays the current simulation #

    %%%Parameters randomly generated at the beginning of each simulation:

    environment=round(abs(10*randn(1,environment_size)));   % this is an ad-hoc function giving some high and many low numbers.
    %n_observe=1;                                           % set the number of individuals observed

   
    %%%Initial storage vectors for each individual:
    
    if s <= number_of_simulations
        strategy_vector=ones(1,population_size);
    else
        strategy_vector=zeros(1,population_size);
    end
    
    round_alive_vector=zeros(1,population_size);
    payoff_vector=zeros(1,population_size);
    new_exploit=zeros(2,1); %records action and payoffs of exploiters in previous round

    for a=1:population_size
        rep_storage{a}=zeros(2,1); %#ok<AGROW> %this will store the repertoires for each individual
        hist_storage{a}=zeros(4,1); %#ok<AGROW> %this will store the history for each individual
    end

        
    %%%Start runnng rounds
    for r=1:number_of_rounds
        
        
        
        %if r-(number_of_rounds/10)*floor((r/(number_of_rounds/10)))==0
        %    disp(r)
        %end
        
        
        prev_exploit=new_exploit; %takes exploit vector from last round and saves for use by observe
        new_exploit=zeros(2,1);   %resets the explout vector to zero
        strat_tracker(r)=sum(strategy_vector); %#ok<AGROW> %this is just to plot the proportion of individuals at the end
        
        %Individuals are selected sequentially to choose a move until all individuals have played. 
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PICK MOVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for b=1:population_size  %FOR EACH INDIVIDUAL
               

            
            if strategy_vector(b)==1    
                [move,myRep]=feval(strategy1, round_alive_vector(b), rep_storage{b}, hist_storage{b}); %Calls one strategy
            else
                [move,myRep]=feval(strategy2, round_alive_vector(b), rep_storage{b}, hist_storage{b}); %Calls the other strategy
            end

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INNOVATE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if move==-1 
                
                
                if r > number_of_rounds - final_population_range  %counts number of innovates in last quarter of simulation for each strategy
                    if strategy_vector(b)==1
                        strat1_innovate_tracker(s)=strat1_innovate_tracker(s)+1;
                    else 
                        strat2_innovate_tracker(s)=strat2_innovate_tracker(s)+1;
                    end
                end
                    
                
                
                %%%%%%%%%%%Select Action%%%%%%%%%%%
                if sum(myRep)==0 %checks to see if this is the first round
                    pick=ceil(environment_size*rand);
                    myRep=[pick;environment(pick)];
                    
                    round_alive_vector(b)=round_alive_vector(b)+1;
                    rep_storage{b}=myRep; %#ok<AGROW>
                    
                    if sum(hist_storage{b})==0
                        hist_storage{b}=[round_alive_vector(b); move; myRep]; %#ok<AGROW>
                    else
                        hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; myRep]]; %#ok<AGROW>
                    end
                
                
                elseif length(myRep) < environment_size %checks that the repertoire isn't already full
                    repeat_test=1;
                    myRep_size=size(myRep);  
                    %this while/for/if loop checks to make sure that the newaction isn't already in the repertoire
                    while repeat_test==1
                        repeat_test=0;
                        new_action=ceil(environment_size*rand);
                        for c=1:myRep_size(2)
                            if myRep(1,c)==new_action;
                                repeat_test=1;
                            end
                        end
                    end
                
                    %%%%%%%%%%%UPdate round alive%%%%%%%%
                    round_alive_vector(b)=round_alive_vector(b)+1;
                
                    %%%%%%%%%%%Update myRep%%%%%%%
                    rep_storage{b}=[myRep, [new_action; environment(new_action)]]; %#ok<AGROW> %updates the repertoire

                    %%%%%%%%%%%Update history%%%%%%%%
                    hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; new_action; environment(new_action)]]; %#ok<AGROW>
                
                else
                    round_alive_vector(b)=round_alive_vector(b)+1;
                    
                    hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; 0; 0]]; %#ok<AGROW>
                    
                    rep_storage{b}=myRep; %#ok<AGROW>
                    
                end
            
    
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OBSERVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
            elseif move==0
                   
                if r > number_of_rounds - final_population_range  %counts number of observes in last quarter of simulation for each strategy
                    if strategy_vector(b)==1
                        strat1_observe_tracker(s)=strat1_observe_tracker(s)+1;
                    else 
                        strat2_observe_tracker(s)=strat2_observe_tracker(s)+1;
                    end
                end
                    
                
                if sum(prev_exploit)~=0 %checks that there were exploiters in the previous round
                
                    prev_exploit_size=size(prev_exploit);  
                    pick=ceil(rand*prev_exploit_size(2)); %picks a previous exploiter to observe
                
                
                    if rand > prob_observed_wrong_act %checks if learner perceives the right action
                        percieved_action=prev_exploit(1,pick); %perceives the right action
                    else
                        percieved_action=ceil(rand*environment_size); %perceives some other action
                    end
                
                    percieved_payoff=abs(round(environment(prev_exploit(1,pick))+randn*observe_error_stdv)); %includes error terms, uses true action
                                
                
                    check_in_rep=0; 
                    rep_size=size(myRep);

                    for x=1:rep_size(2)    %this loop checks if the percieved action is already in the repertoir                              
                        if percieved_action==myRep(1,x)
                            check_in_rep=1;
                            check_location=x;
                            break
                        end
                    end
                
                
                    if check_in_rep~=1
                        myRep=[myRep, [percieved_action; percieved_payoff]]; %#ok<AGROW> %adds move to repertoir
                    else
                        myRep(2,check_location)=percieved_payoff; %replaces old payoff for existing move with percieved payoff
                    end
                             
                    round_alive_vector(b)=round_alive_vector(b)+1; %updates the number of rounds alive
                
                    rep_storage{b}=myRep; %#ok<AGROW>
                           
                    if sum(hist_storage{b})==0
                        hist_storage{b}=[round_alive_vector(b); move; percieved_action; percieved_payoff]; %#ok<AGROW>
                    else
                        hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; percieved_action; percieved_payoff]]; %#ok<AGROW>
                    end
                
                
                
                else    %this only applies when there were no exploiters in the previous round
                    
                    round_alive_vector(b)=round_alive_vector(b)+1; %updates the number of rounds alive
                
                    rep_storage{b}=myRep;  %#ok<AGROW> %keeps the same repetoir
                                  
                    if sum(hist_storage{b})==0   %adds zeros to the history
                        hist_storage{b}=[round_alive_vector(b); move; 0; 0]; %#ok<AGROW>
                    else
                        hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; 0; 0]]; %#ok<AGROW>
                    end
                
                end
     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EXPLOIT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                           
            else
            
                if r > number_of_rounds - final_population_range  %counts number of exploits in last quarter of simulation for each strategy
                    if strategy_vector(b)==1
                        strat1_exploit_tracker(s)=strat1_exploit_tracker(s)+1;
                    else 
                        strat2_exploit_tracker(s)=strat2_exploit_tracker(s)+1;
                    end
                end
                
                
                
                check_in_rep=0;
                rep_size=size(myRep);
            
            
            
                for x=1:rep_size(2)
                    if move==myRep(1,x)
                        check_in_rep=1;
                        check_location=x;
                    end
                end
            
            
            
                if check_in_rep==1 %check to make sure move is in repetoire
                
                    payoff_vector(b)=payoff_vector(b)+environment(move); %add payoff from environment to total payoff

                    myRep(2, check_location)=environment(move);%update repetoire with payoff

                    round_alive_vector(b)=round_alive_vector(b)+1; %increase age by one
                    rep_storage{b}=myRep;  %#ok<AGROW> %store new repetoire
                    hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; move; environment(move)]]; %#ok<AGROW> %store new history
                        
                    if sum(new_exploit)~=0 %new_exploit is used to track the actions and payoffs of the exploiters for observers in the next round
                        new_exploit=[new_exploit, [move; environment(move)]];  %#ok<AGROW>
                    else
                        new_exploit=[move; environment(move)];%this happens the first time an agent exploits in a round.
                    end
                
                else  %if it isn't in repertoire
                    round_alive_vector(b)=round_alive_vector(b)+1; %increase age by one
                    rep_storage{b}=myRep; %#ok<AGROW>
                
                    if sum(hist_storage{b})==0
                        hist_storage{b}=[round_alive_vector(b); move; 0; 0]; %#ok<AGROW>
                    else
                        hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; 0; 0]]; %#ok<AGROW>
                    end
                
                end
            end
        
        %hist_storage{b} %turn this on to check that the histories make sense   
        
        end
        
        
    %%%%%%%%%%%%%%%%%%%Individuals reproduce with probabilities proportional to their average lifetime payoffs%%%%%%%%%%%%%%%%%%%%%%%%
                
        if sum(payoff_vector)==0;
            strat1_prob=sum(strategy_vector)/population_size; % This avoids dividing by zero
        else
            avg_payoff_vector=payoff_vector./round_alive_vector; %Sums payoffs/age for strategy 1 in units/years
            strat1_prob=sum(strategy_vector.*avg_payoff_vector)/sum(avg_payoff_vector);
        end
    



        for d=1:population_size %for each individual
            if rand < death_rate %check to see if it dies
                if (rand < mutation_rate) && (r > settlement_time) %checks if there is a mutation and it is past the settlement time
                    
                    if strategy_vector(d)==1 %mutates strategy by switching ones and zeros
                        %disp('mutate')
                        strategy_vector(d)=0;
                    else
                        strategy_vector(d)=1;   
                    end        
                
                elseif rand < strat1_prob   %if no mutation or before settlementtime checks it's strategy 1's offspring
                    strategy_vector(d)=1;  
                else                        %otherwise it must be strategy 2's offspring .
                    %disp('reproduce')
                    strategy_vector(d)=0;
                end   
            
                round_alive_vector(d)=0; %resets the rounds alive vector for newborn
                rep_storage{d}=zeros(2,1); %#ok<AGROW> %resets the repertoires for newborn
                hist_storage{d}=zeros(4,1); %#ok<AGROW> %resets the history for newborn
                payoff_vector(d)=0; %resets payoff vector for newborn
            end
        end



    
%%%%%%%%%%%%%%%%%%%The environment changes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        for e=1:environment_size
            if rand < prob_of_env_change
                environment(e)=floor(abs(10*randn));
            end
        end
                
        
    end
    
    
 %%%%%%%%%%%%%%%%%%End of Rounds%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
  
    final_strat1_pop_tracker(s)=mean(strat_tracker(number_of_rounds-final_population_range:number_of_rounds)); %takes and stores population of strat 1 (averaged of last ## rounds)  

    if mean(final_strat1_pop_tracker(s))>population_size/2      %Strategy 1 wins
        winner_tracker{s}=strategy1_str;  %#ok<AGROW>
    elseif mean(final_strat1_pop_tracker(s))==population_size/2 %Tie
        winner_tracker{s}='Tie'; %#ok<AGROW>
    else                                                        %Strategy 2 wins
        winner_tracker{s}=strategy2_str; %#ok<AGROW> 
    end
    
    strat1_innovate_tracker(s)=strat1_innovate_tracker(s)/sum(strat_tracker(number_of_rounds-final_population_range:number_of_rounds));
    strat1_observe_tracker(s)=strat1_observe_tracker(s)/sum(strat_tracker(number_of_rounds-final_population_range:number_of_rounds));
    strat1_exploit_tracker(s)=strat1_exploit_tracker(s)/sum(strat_tracker(number_of_rounds-final_population_range:number_of_rounds));
      
    
    strat2_innovate_tracker(s)=strat2_innovate_tracker(s)/(population_size*(final_population_range+1)-sum(strat_tracker(number_of_rounds-final_population_range:number_of_rounds)));
    strat2_observe_tracker(s)=strat2_observe_tracker(s)/(population_size*(final_population_range+1)-sum(strat_tracker(number_of_rounds-final_population_range:number_of_rounds)));
    strat2_exploit_tracker(s)=strat2_exploit_tracker(s)/(population_size*(final_population_range+1)-sum(strat_tracker(number_of_rounds-final_population_range:number_of_rounds)));
    
    disp(sprintf('%d \t \t %0.2f  \t %0.2f  \t %0.2f \t %0.2f \t | \t %0.2f \t %0.2f \t %0.2f \t %0.2f \t | %s', s, strat1_innovate_tracker(s),strat1_observe_tracker(s),strat1_exploit_tracker(s), final_strat1_pop_tracker(s),strat2_innovate_tracker(s),strat2_observe_tracker(s),strat2_exploit_tracker(s),population_size-final_strat1_pop_tracker(s),winner_tracker{s}));

end    
         

%Calculate overall winner:
mean_final_strat1_pop=mean(final_strat1_pop_tracker);

if mean_final_strat1_pop > population_size/2     %strategy 1 wins
    overall_winner=strategy1_str; 
    overall_loser=strategy2_str;
elseif mean_final_strat1_pop==population_size/2 %Tie   
    overall_winner='Tie';
else
    overall_winner=strategy2_str; %strategy 2 wins
    overall_loser=strategy1_str;
end

%Output Round Data and Overall Winner








disp(sprintf('\n'));
disp(sprintf('\n'));
disp(sprintf('Winner Average Pop \t Overall Winner'));

if mean_final_strat1_pop > population_size/2
    disp(sprintf('%0.2f \t \t \t \t %s', mean_final_strat1_pop, overall_winner));
elseif mean_final_strat1_pop < population_size/2
    disp(sprintf('%0.2f \t \t \t \t %s', population_size-mean_final_strat1_pop, overall_winner));
else
    disp(sprintf('TIE!!!'));
end
     
disp(sprintf('Loser Average Pop \t Overall Loser'));

if mean_final_strat1_pop > population_size/2
    disp(sprintf('%0.2f \t \t \t \t %s', population_size-mean_final_strat1_pop, overall_loser));
elseif mean_final_strat1_pop < population_size/2
    disp(sprintf('%0.2f \t \t \t \t %s', mean_final_strat1_pop, overall_loser));
else
    disp(sprintf('TIE!!!'));
end


%subplot(1,2,1)
%hold off;
%subplot(1,2,2)
%hold off;


    
    








