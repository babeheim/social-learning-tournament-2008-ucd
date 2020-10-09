

%%%%%%%%%%%%%%NEED TO ADD:
%Death and Birth
%Populate & update strategy vector (right now all ones)
%Calculate average payoffs at the end
%Determine winner, repeat for 1000 times
%%%%%%%%%%%%%%%%%%%%%%%

%%%House-keeping:

clc;                            % clears command screen
clear;                          % clears all variables
rand('state',sum(100*clock));   % resets random number generator
randn('state',sum(100*clock));  % resets normal random number generator

%%%These parameters are defined in the tournament rules:

population_size=100;    %populations size
number_of_rounds=1000;   %number of rounds
environment_size=100;   %size of environment/number of different actions
death_rate=0.02;        %rate of death (individuals/round)
mutation_rate=0.02;     %rate of mutation (mutants/birth)
settlement_time=100;    %number of rounds invaded strategy has to settle before invasion starts

%%%Parameters randomly generated at the beginning of each simulation:

environment=floor(abs(10*randn(1,environment_size)));   % this is an ad-hoc function giving some high and many low numbers.
%n_observe=1;                                            % set the number of individuals observed
prob_of_env_change_pc=0.399*rand+0.001;                 % select a random probability of environmental change (pc) (assumes a uniform distribution)
prob_observed_wrong_act=rand/2;                         % select a probability of misobserving which act was seen (assumes uniform distribution)
observe_error_stdv=10*rand;                             % selects standard deviation of the observation error rate (assumes uniform distribution)

%%%Each individual has three storage vectors
strategy_vector=ones(1,population_size);
round_alive_vector=zeros(1,population_size);
payoff_vector=zeros(1,population_size);

new_exploit=zeros(2,1); %records action and payoffs of exploiters in previous round

for a=1:population_size
    rep_storage{a}=zeros(2,1); %this will store the repertoires for each individual
    hist_storage{a}=zeros(4,1); %this will store the history for each individual
end

%%Ok, so now we've defined everything basic about what an agent has...

%%%Start running rounds - this is a huge for loop, which runs the whole thing
for r=1:number_of_rounds
    r %print the round number, just to keep track
    prev_exploit=new_exploit; %takes exploit vector from last round and saves for use by observe
    new_exploit=zeros(2,1);   %resets the exploit vector to zero
    strat_tracker(r)=sum(strategy_vector); %this is just to plot the proportion of individuals at the end
    
%%%%%% Now, individuals are selected sequentially to choose a move until
%%%%%% all individuals have played.%%%%    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PICK MOVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for b=1:population_size  %FOR EACH INDIVIDUAL
        if strategy_vector(b)==1 %if the strategy vector of that individual is equal to 1, its a Strat 1 - go talk to that m file
            [move,myRep]=always_innovate(round_alive_vector(b), rep_storage{b}, hist_storage{b}); %Calls one strategy
        else %if the strategy vector is equal to something else, its a Strat 2 - go talk to THAT m file
            [move,myRep]=innovate_then_split(round_alive_vector(b), rep_storage{b}, hist_storage{b}); %Calls the other strategy
        end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INNOVATE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%contains all the consequences to the organism if they innovate, in three
%%%situations: the first move, when the repertoire is not full, and when
%%%the rep is full??
        if move==-1 %-1 is innovate, the cost of R&D 
            %%%%%%%%%%%Select Action%%%%%%%%%%%
            if sum(myRep)==0 %which only happens on the first round, thus giving us first-round-detector
                pick=ceil(environment_size*rand); %ceil is a command that always rounds up, thus giving us the pick
                myRep=[pick;environment(pick)]; %innovate Action 24 and record its payoff
                
                round_alive_vector(b)=round_alive_vector(b)+1; %mark "1" round alive in that vector
                rep_storage{b}=myRep;
                
                if sum(hist_storage{b})==0 %this chunk records the history of the organism 
                    hist_storage{b}=[round_alive_vector(b); move; myRep];
                else
                    hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; myRep]]; %no idea what's going on here
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
                
                %%%%%%%%%%%Update round alive%%%%%%%%
                round_alive_vector(b)=round_alive_vector(b)+1;
                
                %%%%%%%%%%%Update myRep%%%%%%%
                rep_storage{b}=[myRep, [new_action; environment(new_action)]]; %updates the repertoire

                %%%%%%%%%%%Update history%%%%%%%%
                hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; new_action; environment(new_action)]];
                
            else %this is only reserved when the rep is full, right?  it probably never gets executed
                round_alive_vector(b)=round_alive_vector(b)+1;
                
                hist_storage{b}=[hist_storage{b}, [round_alive_vector(b); move; 0; 0]];
                
                rep_storage{b}=myRep;
                
            end
            

            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OBSERVE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        elseif move==0 %0 is observe
                        
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
    
    %% We've gone through each individual...now, to execute some other
    %% stuff for this particular round, then start again on the next round
    
    %%%%%%%%%%%%%%%%%%%Individuals reproduce with probabilities proportional to their average lifetime payoffs%%%%%%%%%%%%%%%%%%%%%%%%
        
    total_strat1_payoff=sum(strategy_vector.*payoff_vector./round_alive_vector); %Sums payoffs/age for strategy 1 in units/years       
    
    strategy2_vector=abs(strategy_vector-ones(1,population_size)); %A clunky way of switching the ones to zeros  
    total_strat2_payoff=sum(strategy2_vector.*payoff_vector./round_alive_vector); %Sums payoffs/age for strategy 1 in units/years  
    
    %Calculate probability that strategy 1 will be the parent:
    
    if total_strat1_payoff==total_strat2_payoff
        strat1_prob=.5; % This is here primarily to avoid dividing by zero if both payoffs are zero
    else
        strat1_prob=total_strat1_payoff/(total_strat1_payoff+total_strat2_payoff); %makes the payoff proportional to the sum of the average payoffs per round
    end
    
    


    for d=1:population_size %for each individual
        if rand < death_rate %check to see if it dies
            if (rand < mutation_rate) & (r > settlement_time) %checks if there is a mutation and it is past the settlement time
                if strategy_vector(d)==1 %mutates strategy by switching ones and zeros
                    strategy_vector(d)=0;
                else
                    strategy_vector(d)=1;   
                end        
                
            elseif rand < strat1_prob   %if no mutation or before settlementtime checks it's strategy 1's offspring
                strategy_vector(d)==1;  
            else                        %otherwise it must be strategy 2's offspring .
                strategy_vector(d)==0;
            end   
            
            round_alive_vector(d)=0; %resets the rounds alive vector for newborn
            rep_storage{d}=zeros(2,1); %resets the repertoires for newborn
            hist_storage{d}=zeros(4,1); %resets the history for newborn  
        end
    end



    
%%%%%%%%%%%%%%%%%%%The environment changes, each round into the next %%%%%%

%%Let's keep the environment stable while I work on strategies...
%         for e=1:environment_size
%             if rand < prob_of_env_change_pc
%                 environment(e)=floor(abs(10*randn));
%             end
%         end

       
%%%%%%%%%%%%%%%%%%End of Round, repeat until all rounds are done%%%%%%    
    
    
end
    
%The melee calculations are now complete....


plot(strat_tracker)
axis([0  number_of_rounds 0 population_size]); %sets the axis dimensions
xlabel('Rounds');
ylabel('Number of Strategy 1 Individuals');
    
%for x=1:population_size
    
%    reptest=rep_storage{x}
%    histtest=hist_storage{x}
    
%end

    
    








