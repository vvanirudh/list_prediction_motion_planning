function [mean_error, std_error] = evaluate_list_prediction( test_data, S)
%EVALUATE_PREDICTION Summary of this function goes here
%   Detailed explanation goes here
% S: N x B
error = [];
for i = 1:length(test_data)
	min_list_cost = min(test_data(i).costs(S(i,:)));
    error = [error (min_list_cost - min(test_data(i).costs))];
end

mean_error = mean(error);
std_error = std(error);
end

