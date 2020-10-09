
clc;                            % clears command screen
clear;                          % clears all variables
rand('state',sum(100*clock));   % resets random number generator
randn('state',sum(100*clock));  % resets normal random number generator
results_matrix=zeros(4);


prob_of_env_change=0.1;
prob_observed_wrong_act=.25;
observe_error_stdv=5;

strategy1=@innovate_observe_then_exploit;
strategy2=@observe_twice_then_exploit;
strategy3=@observe_twice_then_exploit;

[low_results_matrix(1,2),results_matrix(2,1)]=rr_tournament_10(prob_of_env_change, prob_observed_wrong_act, observe_error_stdv, strategy1, strategy2);

[low_results_matrix(1,2),results_matrix(2,1)]=rr_tournament_10(prob_of_env_change, prob_observed_wrong_act, observe_error_stdv, strategy1, strategy3);