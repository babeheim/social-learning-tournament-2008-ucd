
clc;                            % clears command screen
clear;                          % clears all variables
rand('state',sum(100*clock));   % resets random number generator
randn('state',sum(100*clock));  % resets normal random number generator
results_matrix=zeros(4);


low_prob_of_env_change=0.01;
low_prob_observed_wrong_act=0;
low_observe_error_stdv=1;

med_prob_of_env_change=0.2;
med_prob_observed_wrong_act=0.25;
med_observe_error_stdv=5;

high_prob_of_env_change=0.4;
high_prob_observed_wrong_act=0.5;
high_observe_error_stdv=10;

strategy1=@w00t;
strategy2=@w00t_nomagic;

[low_results_matrix(1,2),results_matrix(2,1)]=rr_tournament_11(med_prob_of_env_change, med_prob_observed_wrong_act, med_observe_error_stdv, strategy1, strategy2);


