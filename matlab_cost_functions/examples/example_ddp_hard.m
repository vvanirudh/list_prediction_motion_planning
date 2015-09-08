%% 

clc;
clear;
close all;

load map_ddp_hard.mat;

figure;
visualize_map(map);

cost_map = create_obstacle_cost_map(map, 20);
figure;
visualize_cost_map(cost_map);
