

%MELEE_TOURNAMENT_2 Runs melee phase of the culturadaptation tournament
%
%Inputs: probability of environmental change
%        probability of observing the wrong act
%        standard deviation of the observation error
%        number of individuals observed
%        a list of strategies (must be at least two strategies long)
%
%Outputs: final population of the stategies (including the invaded
%strategy)
%
%Note that the strategy list must be enclosed within the {} brackets and
%include the @ symbol at the beginning of each strategy name
%
%Also note that the first strategy on the list is the invaded strategy.
%For the actual tournament, innovate_then_exploit is used.  The invaded 
%strategy is not replaced through mutation.
%
%Example:
%melee_tournament_1(.001, .2, 5, 3, {@innovate_then_exploit @always_innovate @iwpd @cwpd @experimenter @innovate_then_exploit @stdDevTrigger @choosy_experimenter2})
%

function [mean_strategy_pop]=melee_tournament_2_exp(prob_of_env_change, prob_observed_wrong_act, observe_error_stdv, n_observe, strategy_list)



number_of_strategies=size(strategy_list,2); %uses length of input strategy list to detemine the number of strategies

%%%These parameters are defined in the tournament rules:

population_size=100;    %populations size
number_of_rounds=10000;  %number of rounds
environment_size=100;   %size of environment/number of different actions
death_rate=0.02;        %rate of death (individuals/round)
mutation_rate=0.02;     %rate of mutation (mutants/birth)
mutation_exclusion_time=round(number_of_rounds/4); %mutations are excluded from the end of the melee tournament

%%%%Parameters used to run many simulations to find ultimate winner
number_of_simulations=10;                              %total number of simulations run between two strategies for each invasion situation
final_population_range=round(number_of_rounds/4);      %The number of rounds used to calculate the winning population

%%%Tracking vectors for each simulation that are outputs at the end
winner_tracker=zeros(1,number_of_simulations);

disp(' ')
disp(' ')

for s=1:number_of_simulations
    
    %disp(s) %displays the current simulation #

    %%%Parameters randomly generated at the beginning of each simulation:

    environment=round(exprnd(8,1,100));    % this is an ad-hoc function giving some high and many low numbers.
    %n_observe=1;                                           % set the number of individuals observed

   
    %%%Initial storage vectors for strategies - all ones "innovate_then_exploit"
    
    strategy_vector=ones(1,population_size); %all are innovate_then_exploit
    
    %%%Tracks population of each strategy the first strategy always starts first

    strategy_pop_tracker=zeros(number_of_rounds, number_of_strategies);
    
    
    
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
        
        %Individuals are selected sequentially to choose a move until all individuals have played. 
        

        for b=1:population_size  %FOR EACH INDIVIDUAL
            
           strategy_pop_tracker(r,strategy_vector(1,b))=strategy_pop_tracker(r,strategy_vector(1,b))+1;
            
            
            
            
            
            
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PICK MOVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
            
            [move,myRep]=feval(strategy_list{1,strategy_vector(b)}, round_alive_vector(b), rep_storage{b}, hist_storage{b}); %Calls strategy
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INNOVATE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if move==-1 
                
                    
                
                
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
                   
                round_alive_vector(b)=round_alive_vector(b)+1;
                
                if sum(prev_exploit)~=0 %checks that there were exploiters in the previous round
                
                    prev_exploit_size=size(prev_exploit);  
                    
                    for o=1:n_observe
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

                        if sum(hist_storage{b})==0
                            hist_storage{b}=[round_alive_vector(b); move; percieved_action; percieved_payoff]; %#ok<AGROW>
                        else
                            hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; percieved_action; percieved_payoff]]; %#ok<AGROW>
                        end
                        
                    end

                    rep_storage{b}=myRep; %#ok<AGROW>
                    
                     %updates the number of rounds alive
                
                
                else    %this only applies when there were no exploiters in the previous round
                    
                
                    rep_storage{b}=myRep;  %#ok<AGROW> %keeps the same repetoir
                    
                    for o=1:n_observe
                    
                        if sum(hist_storage{b})==0   %adds zeros to the history
                            hist_storage{b}=[round_alive_vector(b); move; 0; 0]; %#ok<AGROW>
                        else
                            hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; 0; 0]]; %#ok<AGROW>
                        end
                        
                    end
                
                end

                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EXPLOIT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                           
            else
               
                
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
            avg_payoff_vector=ones(1,population_size); % This avoids dividing by zero
        else
            avg_payoff_vector=payoff_vector./round_alive_vector; %Sums payoffs/age for strategy 1 in units/years
        end

       
        
        total_strategy_score_vector=zeros(1,number_of_strategies);        
        for q=1:population_size  %sums payoff_per_round scores for each strategy
           total_strategy_score_vector(1,strategy_vector(1,q))=total_strategy_score_vector(1,strategy_vector(1,q))+avg_payoff_vector(1,q); 
        end
        
        
        
        total_strategy_score_vector=total_strategy_score_vector/sum(total_strategy_score_vector); %normalizes the vector so it sums to 1
        
        

        for d=1:population_size %for each individual
            if rand < death_rate %check to see if it dies
                
                            
                
                if (rand < mutation_rate) && (r < number_of_rounds - mutation_exclusion_time) %checks if there is a mutation and it is past mutation time
                    %disp('mutate');
                    strategy_vector(1,d)=ceil((rand*(number_of_strategies-1)))+1; %replaces strategy with a random strategy (except for invaded strategy
                    
                else  %no mutation
                    %disp('reproduce')
                    %total_strategy_score_vector
                    reproduce_picker=rand;
                    reproduce_counter=0;             
                    focal_strategy=0;    
                    
                    while reproduce_picker >= reproduce_counter 
                        focal_strategy=focal_strategy+1;
                        reproduce_counter=reproduce_counter+total_strategy_score_vector(focal_strategy); %replaces strategy with a random strategy proportional to population size * payoff_per_rounds_alive 
                              
                    end

                    strategy_vector(1,d)=focal_strategy;
                    
                end   
            
                round_alive_vector(d)=0; %resets the rounds alive vector for newborn
                rep_storage{d}=zeros(2,1); %#ok<AGROW> %resets the repertoires for newborn
                hist_storage{d}=zeros(4,1); %#ok<AGROW> %resets the history for newborn
                payoff_vector(d)=0; %resets payoff vector for newborn
                
                %disp('after');
                %strategy_pop_tracker
                
                
            end
            
        end



    
%%%%%%%%%%%%%%%%%%%The environment changes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        for e=1:environment_size
            if rand < prob_of_env_change
                environment(e)=round(exprnd(8));
            end
        end
                
        
    end
    
    
 %%%%%%%%%%%%%%%%%%End of Rounds%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
  
     
    mean_strategy_pop(s,:)=mean(strategy_pop_tracker(number_of_rounds-final_population_range:number_of_rounds,:)); %#ok<AGROW> %Stores strategy populations averaged over last ## of rounds
    
    disp(mean_strategy_pop(s,:));

    if size(max(mean_strategy_pop(s,:)),2)==1 %checks for ties.  Ties are represented by zeros
    
        %mean_strategy_pop(s,:)
        %max(mean_strategy_pop(s,:))
        
        winner_tracker(1,s)=find(mean_strategy_pop(s,:)==max(mean_strategy_pop(s,:))); %#ok<AGROW> % Tracks the winning strategy from each simulation
    end
    
end
    
        

%Output Round Data and Overall Winner


%disp(sprintf('\n'));
%disp(sprintf('\n'));
%disp(sprintf('Winner Average Pop \t Overall Winner'));


%disp(sprintf('%0.2f \t \t \t \t %s', max(mean_strategy_pop(s,:), overall_winner));

     
%disp(sprintf('Loser Average Pop \t Overall Loser'));

%if mean_final_strat1_pop > population_size/2
%    disp(sprintf('%0.2f \t \t \t \t %s', population_size-mean_final_strat1_pop, overall_loser));
%elseif mean_final_strat1_pop < population_size/2
%    disp(sprintf('%0.2f \t \t \t \t %s', mean_final_strat1_pop, overall_loser));
%else
%    disp(sprintf('TIE!!!'));
%end

%mean_final_strat2_pop=population_size-mean_final_strat1_pop;


%subplot(1,2,1)
%hold off;
%subplot(1,2,2)
%hold off;