clc;
clear;
close all;

% load ../saved_maps/rect_set.mat
% bbox = [-1 1 -1 1];

load ../saved_maps/shapes_convex_opt_proj.mat
bbox = [0 1 0 1];

for count = 1:length(shapes_array)
    rectangle_array(count).low = shapes_array(count).data(1:2);
    rectangle_array(count).high = shapes_array(count).data(1:2) + shapes_array(count).data(3:4);
end

resolution = 0.001;

map = rectangle_maps( bbox, rectangle_array, resolution);

%% Admire work
figure;
visualize_map(map);