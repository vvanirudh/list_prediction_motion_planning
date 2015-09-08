function features = scp_features_data_instance(data_instance,prev_slot_features,S,mode)
% data_instance is a struct 
% prev_slot_features is cell of size [1,K]. prev_slot_features{i} is [L,d]
% S is of size [1,K]
% mode is type of features
% features is [L,d]

switch mode
	case 'lib'
		simple_features = data_instance.lib_contexts;
	case 'query'
		simple_features = data_instance.query_contexts;
	case 'libquery'
		simple_features = [data_instance.query_contexts data_instance.lib_contexts];
	otherwise
		error('INVALID CHOICE');
end

[L,d1] = size(simple_features);
K = length(prev_slot_features);
d = 3*d1+1;
features = zeros(L,d);

% for each library element
% features from previous predictions
% taken from SCP paper.
for j = 1:L
	prev_slot_features_j = zeros(K,d1);
	
	% first level
	if K == 0
		features(j,1:d1) = simple_features(j,:);
		continue;
	end
	
	for k = 1:K
		tmp = prev_slot_features{k};
		prev_slot_features_j(k,:) = tmp(S(k),1:d1);
	end
	diff_features = bsxfun(@minus,prev_slot_features_j,simple_features(j,:));
	abs_diff_features = abs(diff_features); % size [K,d1].
	min_abs_diff_features = min(abs_diff_features,[],1);
	mean_abs_diff_features = mean(abs_diff_features,1);
	features(j,:) = [simple_features(j,:) min_abs_diff_features mean_abs_diff_features 1];
end

% % add bias
% features = [features ones(L,1)];

end