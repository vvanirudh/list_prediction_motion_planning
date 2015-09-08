%% Cost map for ICRA

clc;
clear;
close all;

load map_081614.mat;

figure;
visualize_map(map);

cost_map = create_obstacle_cost_map(map, 0.15);
figure;
visualize_cost_map(cost_map);
