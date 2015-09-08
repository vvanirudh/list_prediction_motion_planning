%% Cost map for ICRA

clc;
clear;
close all;

load ../../matlab_environment_generation/saved_maps/map_convex_opt_proj.mat;

figure;
visualize_map(map);

cost_map = create_obstacle_cost_map(map, 0.05);
figure;
visualize_cost_map(cost_map);
