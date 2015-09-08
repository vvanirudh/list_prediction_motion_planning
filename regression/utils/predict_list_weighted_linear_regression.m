function S = predict_list_weighted_linear_regression( test_data, beta_list, mode )
% test_data is in common format
% beta_list is length B cell array. beta_list{i} is [d,1]
%
% S is [N,B]

B = length(beta_list);
N = length(test_data);
S = zeros(N,B);

for k = 1:B
	features = conseqopt_features(test_data,S(:,1:k-1),mode);
% 	features = conseqopt_scp_features(test_data,S(:,1:k-1),mode);
	for i = 1:N
		S(i,k) = predict_slot_weighted_linear_regression(features{i},beta_list{k});
	end
end

end