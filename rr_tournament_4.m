


%%%House-keeping:

clc;                            % clears command screen
clear;                          % clears all variables
rand('state',sum(100*clock));   % resets random number generator
randn('state',sum(100*clock));  % resets normal random number generator

%%%These parameters are defined in the tournament rules:

population_size=100;    %populations size
number_of_rounds=1000;  %number of rounds
environment_size=100;   %size of environment/number of different actions
death_rate=0.02;        %rate of death (individuals/round)
mutation_rate=0.02;     %rate of mutation (mutants/birth)
settlement_time=100;    %number of rounds invaded strategy has to settle before invasion starts

%%%%Parameters used to run many simulations to find ultimate winner
number_of_simulations=5;                              %total number of simulations run between two strategies for each invasion situation
final_population_range=round(number_of_rounds/4);      %The number of rounds used to calculate the winning population
%final_strat1_pop_vector=zeros(1,number_of_simulations); %Storage vector to track winner of each simulation

for s=1:2*number_of_simulations
    
    disp(s) %displays the current simulation #

    %%%Parameters randomly generated at the beginning of each simulation:

    environment=floor(abs(10*randn(1,environment_size)));   % this is an ad-hoc function giving some high and many low numbers.
    %n_observe=1;                                            % set the number of individuals observed
    prob_of_env_change_pc=0.399*rand+0.001;                 % select a random probability of environmental change (pc) (assumes a uniform distribution)
    prob_observed_wrong_act=rand/2;                         % select a probability of misobserving which act was seen (assumes uniform distribution)
    observe_error_stdv=10*rand;                             % selects standard deviation of the observation error rate (assumes uniform distribution)

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
        rep_storage{a}=zeros(2,1); %this will store the repertoires for each individual
        hist_storage{a}=zeros(4,1); %this will store the history for each individual
    end

        
    %%%Start runnng rounds
    for r=1:number_of_rounds
        
        
        
        if r-100*floor((r/100))==0
            disp(r)
        end
        
        
        prev_exploit=new_exploit; %takes exploit vector from last round and saves for use by observe
        new_exploit=zeros(2,1);   %resets the explout vector to zero
        strat_tracker(r)=sum(strategy_vector); %this is just to plot the proportion of individuals at the end
        
        %Individuals are selected sequentially to choose a move until all individuals have played. 
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PICK MOVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for b=1:population_size  %FOR EACH INDIVIDUAL
               
            if strategy_vector(b)==1    
                [move,myRep]=switch_switch(round_alive_vector(b), rep_storage{b}, hist_storage{b}); %Calls one strategy
            else
                [move,myRep]=simple02(round_alive_vector(b), rep_storage{b}, hist_storage{b}); %Calls the other strategy
            end

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INNOVATE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if move==-1 
                %%%%%%%%%%%Select Action%%%%%%%%%%%
                if sum(myRep)==0 %checks to see if this is the first round
                    pick=ceil(environment_size*rand);
                    myRep=[pick;environment(pick)];
                    
                    round_alive_vector(b)=round_alive_vector(b)+1;
                    rep_storage{b}=myRep;
                    
                    if sum(hist_storage{b})==0
                        hist_storage{b}=[round_alive_vector(b); move; myRep];
                    else
                        hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; myRep]];
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
                    rep_storage{b}=[myRep, [new_action; environment(new_action)]]; %updates the repertoire

                    %%%%%%%%%%%Update history%%%%%%%%
                    hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; new_action; environment(new_action)]];
                
                else
                    round_alive_vector(b)=round_alive_vector(b)+1;
                    
                    hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; 0; 0]];
                    
                    rep_storage{b}=myRep;
                    
                end
            
    
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OBSERVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
            elseif move==0
                        
                if sum(prev_exploit)~=0 %checks that there were exploiters in the previous round
                
                    prev_exploit_size=size(prev_exploit);  
                    pick=ceil(rand*prev_exploit_size(2)); %picks a previous exploiter to observe
                
                
                    if rand > prob_observed_wrong_act %checks if learner perceives the right action
                        percieved_action=prev_exploit(1,pick); %perceives the right action
                    else
                        percieved_action=ceil(rand*environment_size); %perceives some other action
                    end
                
                    percieved_payoff=abs(round(environment(prev_exploit(1,pick))+randn*observe_error_stdv)); %includes error terms, uses true action
                                
                
                    check_same=0; 
                    rep_size=size(myRep);

                    for x=1:rep_size(2)    %this loop checks if the percieved action is already in the repertoir                              
                        if percieved_action==myRep(1,x)
                            check_in_rep=1;
                            check_location=x;
                            break
                        end
                    end
                
                
                    if check_in_rep~=1
                        myRep=[myRep, [percieved_action; percieved_payoff]]; %adds move to repertoir
                    else
                        myRep(2,check_location)=percieved_payoff; %replaces old payoff for existing move with percieved payoff
                    end
                             
                    round_alive_vector(b)=round_alive_vector(b)+1; %updates the number of rounds alive
                
                    rep_storage{b}=myRep;
                           
                    if sum(hist_storage{b})==0
                        hist_storage{b}=[round_alive_vector(b); move; percieved_action; percieved_payoff];
                    else
                        hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; percieved_action; percieved_payoff]];
                    end
                
                
                
                else    %this only applies when there were no exploiters in the previous round
                    
                    round_alive_vector(b)=round_alive_vector(b)+1; %updates the number of rounds alive
                
                    rep_storage{b}=myRep;  %keeps the same repetoir
                                  
                    if sum(hist_storage{b})==0   %adds zeros to the history
                        hist_storage{b}=[round_alive_vector(b); move; 0; 0];
                    else
                        hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; 0; 0]];
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
                    rep_storage{b}=myRep;  %store new repetoire
                    hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; move; environment(move)]]; %store new history
                        
                    if sum(new_exploit)~=0 %new_exploit is used to track the actions and payoffs of the exploiters for observers in the next round
                        new_exploit=[new_exploit, [move; environment(move)]]; 
                    else
                        new_exploit=[move; environment(move)];%this happens the first time an agent exploits in a round.
                    end
                
                else  %if it isn't in repertoire
                    round_alive_vector(b)=round_alive_vector(b)+1; %increase age by one
                    rep_storage{b}=myRep;
                
                    if sum(hist_storage{b})==0
                        hist_storage{b}=[round_alive_vector(b); move; 0; 0];
                    else
                        hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; 0; 0]];
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
                rep_storage{d}=zeros(2,1); %resets the repertoires for newborn
                hist_storage{d}=zeros(4,1); %resets the history for newborn
                payoff_vector(d)=0; %resets payoff vector for newborn
            end
        end



    
%%%%%%%%%%%%%%%%%%%The environment changes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        for e=1:environment_size
            if rand < prob_of_env_change_pc
                environment(e)=floor(abs(10*randn));
            end
        end

       
%%%%%%%%%%%%%%%%%%End of Round%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    
    end
    
    if s <= number_of_simulations
        subplot(1,2,1)
        plot(strat_tracker)
        axis([0  number_of_rounds 0 population_size]); %sets the axis dimensions
        xlabel('Rounds');
        ylabel('Number of Strategy 1 Individuals');
        hold on;
    else
        subplot(1,2,2)
        plot(strat_tracker)
        axis([0  number_of_rounds 0 population_size]); %sets the axis dimensions
        xlabel('Rounds');
        ylabel('Number of Strategy 1 Individuals');
        hold on;
    end
    
    final_strat1_pop_vector(s)=mean(strategy_vector); %takes and stores population of strat 1 (averaged of last ## rounds)
    
end

if mean(final_strat1_pop_vector)>0.5
    disp('Strategy 1 wins');
elseif mean(final_strat1_pop_vector)==0.5
    disp('Tie')
else
    disp('Strategy 2 wins');
end

subplot(1,2,1)
hold off;
subplot(1,2,2)
hold off;

%for x=1:population_size
    
%    reptest=rep_storage{x}
%    histtest=hist_storage{x}
    
%end

    
    








