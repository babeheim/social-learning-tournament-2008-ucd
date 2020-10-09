
clc;                            % clears command screen
clear;                          % clears all variables
rand('state',sum(100*clock));   % resets random number generator
randn('state',sum(100*clock));  % resets normal random number generator

low_prob_of_env_change=0.001;
high_prob_of_env_change=0.4;

low_prob_observed_wrong_act=0;
high_prob_observed_wrong_act=0.5;

low_observe_error_stdv=0;
high_observe_error_stdv=10;


strategy1=@experimenter;
strategy2=@cwpd;
strategy3=@stdDevTrigger;
strategy4=@iwpd;
%strategy5=@switch_switch;
%strategy6=@innovate_then_exploit;
%strategy7=@maximus;
%strategy8=@huntForPrettyGood;
%strategy9=@ryan_strategy;
%strategy10=@choosyExperimentor;


tic

rr_tournament_9(low_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy1, strategy2)
rr_tournament_9(low_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy1, strategy2)
rr_tournament_9(high_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy1, strategy2)
rr_tournament_9(high_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy1, strategy2)

toc

tic

rr_tournament_9(low_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy1, strategy3)
rr_tournament_9(low_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy1, strategy3)
rr_tournament_9(high_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy1, strategy3)
rr_tournament_9(high_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy1, strategy3)

toc

tic

rr_tournament_9(low_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy1, strategy4)
rr_tournament_9(low_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy1, strategy4)
rr_tournament_9(high_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy1, strategy4)
rr_tournament_9(high_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy1, strategy4)

toc

tic

rr_tournament_9(low_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy2, strategy3)
rr_tournament_9(low_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy2, strategy3)
rr_tournament_9(high_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy2, strategy3)
rr_tournament_9(high_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy2, strategy3)

toc

tic

rr_tournament_9(low_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy2, strategy4)
rr_tournament_9(low_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy2, strategy4)
rr_tournament_9(high_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy2, strategy4)
rr_tournament_9(high_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy2, strategy4)

toc

tic

rr_tournament_9(low_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy3, strategy4)
rr_tournament_9(low_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy3, strategy4)
rr_tournament_9(high_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, strategy3, strategy4)
rr_tournament_9(high_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, strategy3, strategy4)

toc
