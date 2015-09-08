clc
clear 
close all

library_path = '../dataset/library/';


load(strcat(library_path,'library.mat'), 'library');
lib_contexts = [];

for i = 1:length(library)
    cost_map = library{i}.cost_map;
    [ cost_map_x, cost_map_y] = get_cost_map_derivatives( cost_map );
    [ f ] = get_simple_features( library{i}.traj, cost_map, cost_map_x, cost_map_y );
    lib_contexts = [ lib_contexts; f];
end

save(strcat(library_path,'lib_contexts.mat'), 'lib_contexts');
