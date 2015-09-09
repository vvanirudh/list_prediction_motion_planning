function error_list = stagewise_evaluate_list_prediction( test_data, S)
%EVALUATE_PREDICTION Summary of this function goes here
%   Detailed explanation goes here
% S: N x B
error_list = [];
for i = 1:length(test_data)
    error_list = [error_list; (test_data(i).costs(S(i,:))' - min(test_data(i).costs))];
end

end

