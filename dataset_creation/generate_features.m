clc
clear 
close all

library_path = '../dataset/library/';
cost_data_set = '../dataset/env_cost_map_dataset/';
output_data_set = '../dataset/features_dataset/';


listing = dir(fullfile(cost_data_set,'cost_map*.mat'));
L = 100; % library size

load(strcat(library_path,'library.mat'), 'library');
 
for i = 1:length(listing)
    i
    load(strcat(cost_data_set,'cost_map_',num2str(i),'.mat'), 'cost_map');
    [ cost_map_x, cost_map_y] = get_cost_map_derivatives( cost_map );
    query_contexts = [];
    for j = 1:length(library)
        [ f ] = get_simple_features( library{j}.traj, cost_map, cost_map_x, cost_map_y );
        query_contexts = [ query_contexts; f];
    end
    
    save(strcat(output_data_set, 'query_contexts_',num2str(i),'.mat'), 'query_contexts');
end