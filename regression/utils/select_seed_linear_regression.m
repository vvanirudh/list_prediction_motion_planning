function [ selected_idx ] = select_seed_linear_regression( test_data, beta, mode )
%SELECT_SEED_LINEAR_REGRESSION Summary of this function goes here
%   Detailed explanation goes here

selected_idx = [];
for i = 1:length(test_data)
    X_test = data_transform_regression(test_data(i), mode);
    [~,id] = min(test_data(i).original_costs - X_test*beta);
    selected_idx = [selected_idx; id];
end

end

