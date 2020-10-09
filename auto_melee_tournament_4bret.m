
clc;                            % clears command screen
clear;                          % clears all variables
rand('state',sum(100*clock));   % resets random number generator
randn('state',sum(100*clock));  % resets normal random number generator

low_prob_of_env_change=0.001;
med_prob_of_env_change=0.2;
high_prob_of_env_change=0.4;

low_prob_observed_wrong_act=0;
med_prob_observed_wrong_act=0.25;
high_prob_observed_wrong_act=0.5;

low_observe_error_stdv=0;
med_observe_error_stdv=5;
high_observe_error_stdv=10;

low_number_obs=1;
high_number_obs=5;

strategy1=@innovate_then_exploit; %you shouldn't change this one
strategy2=@bret_strategy3_rhb;
strategy3=@ryan_strategy3_rhb;
strategy4=@matt_strategy3_rhb;
strategy5=@matt_strategy4;
strategy6=@woot_paul;
strategy7=@ryan_strategy;
strategy8=@iwpd;
strategy9=@stdDevTrigger;
strategy10=@innovate_then_exploit;
strategy11=@woot_magic_trigger_pc_learn_50_50_no_lim;




% disp('low p_c   low error low n_o');
% melee_tournament_2_exp(low_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('med p_c   low error low n_o');
% melee_tournament_2_exp(med_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('high p_c  low error low n_o');
% melee_tournament_2_exp(high_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('low p_c   med error low n_o');
% melee_tournament_2_exp(low_prob_of_env_change, med_prob_observed_wrong_act, med_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('med p_c   med error low n_o');
% melee_tournament_2_exp(med_prob_of_env_change, med_prob_observed_wrong_act, med_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});

disp('high p_c  med error low n_o');
melee_tournament_2_exp(high_prob_of_env_change, med_prob_observed_wrong_act, med_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});

disp('low p_c   high error low n_o');
melee_tournament_2_exp(low_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});

disp('med p_c   high error low n_o');
melee_tournament_2_exp(med_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});

disp('high p_c  high error low n_o');
melee_tournament_2_exp(high_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, low_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});

disp('low p_c   low error  high n_o');
melee_tournament_2_exp(low_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});

% disp('med p_c   low error  high n_o');
% melee_tournament_2_exp(med_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('high p_c  low error  high n_o');
% melee_tournament_2_exp(high_prob_of_env_change, low_prob_observed_wrong_act, low_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('low p_c   med error  high n_o');
% melee_tournament_2_exp(low_prob_of_env_change, med_prob_observed_wrong_act, med_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('med p_c   med error  high n_o');
% melee_tournament_2_exp(med_prob_of_env_change, med_prob_observed_wrong_act, med_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('high p_c  med error  high n_o');
% melee_tournament_2_exp(high_prob_of_env_change, med_prob_observed_wrong_act, med_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('low p_c   high error high n_o');
% melee_tournament_2_exp(low_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('med p_c   high error high n_o');
% melee_tournament_2_exp(med_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% disp('high p_c  high error high n_o');
% melee_tournament_2_exp(high_prob_of_env_change, high_prob_observed_wrong_act, high_observe_error_stdv, high_number_obs, {strategy1 strategy2 strategy3 strategy4 strategy5 strategy6 strategy7 strategy8 strategy9 strategy10 strategy11});
% 
% 
% 
% 
% 
% 
% 
% 
