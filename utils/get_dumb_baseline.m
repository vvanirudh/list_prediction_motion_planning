clc
clear
close all

load ../dataset/processed_dataset/validation_data.mat

selected_random_idx = [];
selected_best_original_idx = [];
for i = 1:length(validation_data)
    [~,id1] = min(validation_data(i).original_costs);
    id2 = randi(length(validation_data(i).original_costs));
    selected_random_idx = [selected_random_idx; id2];
    selected_best_original_idx = [selected_best_original_idx; id1];
end
[e1, e2] = evaluate_prediction( validation_data, selected_best_original_idx );
fprintf('Evaluation error (Best original): %f %f\n', e1, e2);
[e1, e2] = evaluate_prediction( validation_data, selected_random_idx );
fprintf('Evaluation error (Random): %f %f\n', e1, e2);
