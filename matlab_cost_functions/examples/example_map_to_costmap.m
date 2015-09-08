
clc;
clear;
close all;

data_set = '../../dataset/env_map_dataset/';
output_data_set = '../../dataset/env_cost_map_dataset/';
epsilon = 0.05;

listing = dir(fullfile(data_set,'map*.mat'));
for i = 1:length(listing)
    load(strcat(data_set,'map_',num2str(i),'.mat'), 'map');
    cost_map = create_obstacle_cost_map(map, epsilon);
    save(strcat(output_data_set, 'cost_map_',num2str(i),'.mat'), 'cost_map');
end

