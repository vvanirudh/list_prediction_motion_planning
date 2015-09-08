clc
clear
close all

traj_data_set = '../dataset/solution_dataset/';
cost_data_set = '../dataset/env_cost_map_dataset/';

listing = dir(fullfile(traj_data_set,'solution*.mat'));
L = 100; % library size

load(strcat(cost_data_set,'cost_map_1.mat'), 'cost_map');
load(strcat(traj_data_set,'solution_1.mat'), 'glob_opt_traj');

library{1}.cost_map = cost_map;
library{1}.traj = glob_opt_traj.x';

for i = 2:L
    i
    similarity_array = 0;
    for j = 2:length(listing)
        load(strcat(traj_data_set,'solution_',num2str(j),'.mat'), 'glob_opt_traj');
        similarity = inf;
        for k=1:(i-1)
            delta = norm(library{k}.traj - glob_opt_traj.x');
            similarity = min(similarity, delta); 
        end
        similarity_array = [similarity_array; similarity];
    end
    [~, max_idx] = max(similarity_array);
    load(strcat(traj_data_set,'solution_',num2str(max_idx),'.mat'), 'glob_opt_traj');
    load(strcat(cost_data_set,'cost_map_',num2str(max_idx),'.mat'), 'cost_map');
    library{i}.cost_map = cost_map;
    library{i}.traj = glob_opt_traj.x';
end

figure;
hold on;
for i = 1:L
    plot(library{i}.traj(:,1), library{i}.traj(:,2));
end