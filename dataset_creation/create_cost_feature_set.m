clc
clear
close all

library_path = '../dataset/library/';
query_contexts_data_set = '../dataset/features_dataset/';
traj_cost_data_set = '../dataset/evaluated_by_library_dataset/';
original_traj_cost_data_set = '../dataset/original_cost_dataset/';


load(strcat(library_path,'lib_contexts.mat'), 'lib_contexts');

listing = dir(fullfile(traj_cost_data_set,'cost_library*.mat'));

for i = 1:length(listing)
    load(strcat(traj_cost_data_set,'cost_library_',num2str(i),'.mat'), 'cost_library');
    load(strcat(original_traj_cost_data_set,'original_cost_library_',num2str(i),'.mat'), 'original_cost_library');
    load(strcat(query_contexts_data_set,'query_contexts_',num2str(i),'.mat'), 'query_contexts');

    data(i).costs = cost_library;
    data(i).lib_contexts = lib_contexts;
    data(i).query_contexts = query_contexts;
    data(i).original_costs = original_cost_library;
end

save ../dataset/processed_dataset/data.mat;
train_data = data(1:700);
test_data = data(901:1000);
validation_data = data(701:900);
save ../dataset/processed_dataset/train_data.mat train_data
save ../dataset/processed_dataset/test_data.mat test_data
save ../dataset/processed_dataset/validation_data.mat validation_data