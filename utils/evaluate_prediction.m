function [mean_error, std_error] = evaluate_prediction( test_data, selected_idx )
%EVALUATE_PREDICTION Summary of this function goes here
%   Detailed explanation goes here

error = [];
for i = 1:length(test_data)
    error = [error (test_data(i).costs(selected_idx(i)) - min(test_data(i).costs))];
end

mean_error = mean(error);
std_error = std(error);
end

