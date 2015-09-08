%% This is an example created by Sanjiban for testing purposes. 
% This is for ICRA '15 results, so dont touch till then.

clc;
clear;
close all;

%% Create analytic world
bbox = [0 1 0 1];
rectangle_array(1).low = [0.2 0.2];
rectangle_array(1).high = [0.4 0.6];
rectangle_array(2).low = [0.6 0.5];
rectangle_array(2).high = [0.8 0.9];
resolution = 0.001;

map = rectangle_maps( bbox, rectangle_array, resolution);

%% Admire work
figure;
visualize_map(map);