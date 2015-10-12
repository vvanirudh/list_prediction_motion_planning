function S = predict_list_cs_classification( test_data, weights_list, features_choice_struct )
% test_data is in common format
% weights_list is length B cell array. beta_list{i} is [d,1]
%
% S is [N,B]

B = length(weights_list);
N = length(test_data);
S = zeros(N,B);

for k = 1:B
	features = conseqopt_features(test_data,S(:,1:k-1),features_choice_struct);
	[class_test_pred,scores_pred] = linear_scorer_predict(features,weights_list{k});
	S(:,k) = class_test_pred;
end

end