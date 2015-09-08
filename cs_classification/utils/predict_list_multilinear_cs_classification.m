function S = predict_list_multilinear_cs_classification( test_data, weights_list)
% test_data is in common format
% weights_list is length B cell array. beta_list{i} is [d,1]
%
% S is [N,B]

B = length(weights_list);
N = length(test_data);
S = zeros(N,B);
[features,~] = data_transform_multilinear_cs_classification(test_data);

for k = 1:B
    [class_test_pred,scores_pred] = multi_linear_scorer_predict(features,weights_list{k});
	S(:,k) = class_test_pred;
end

end