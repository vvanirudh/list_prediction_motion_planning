clc
clear
close all

load '../../../data_set_091914/cost_map_1.mat';

p_start = [6; 95];
p_goal =  [237.5; 95]; 

options.d = 2;
options.n = 100;
options.eta = 700;
options.max_iter = 100;
options.min_iter = 100;
options.min_cost_improv_frac = 0;%1e-3;

w_obs = 0.5;
lambda = 4.5455e-05;
[ cost_traversal, time_taken, cost_history, traj_history, h_traj, h_cost ] = CHOMP(p_start, p_goal, cost_map, w_obs, lambda, options);