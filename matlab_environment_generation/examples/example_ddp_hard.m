%% This is an example created by Sanjiban for testing purposes. 
% This is for ICRA '15 results, so dont touch till then.

clc;
clear;
close all;

%% Create analytic world
bbox = [0 240 0 171.5];
rectangle_array(1).low = [72 25];
rectangle_array(1).high = [110 85];
rectangle_array(2).low = [155 85];
rectangle_array(2).high = [190 150];
resolution = 0.5;

map = rectangle_maps( bbox, rectangle_array, resolution);

%% Admire work
figure;
visualize_map(map);