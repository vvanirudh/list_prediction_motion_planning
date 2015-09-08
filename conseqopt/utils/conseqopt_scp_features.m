function features = conseqopt_scp_features(data,S,mode)
% data is in common format
% S is [N,K]
% mode: {'lib','query','libquery'}
% features is cell array length N. features{i} is [L,d]

[N,K] = size(S);
features = cell(1,N);
L = length(data(1).costs);
d1 = size(data(1).query_contexts,2);
d = 3*d1+1;

for i = 1:N
	switch mode
		case 'lib'
			simple_features = data(i).lib_contexts;
		case 'query'
			simple_features = data(i).query_contexts; % [L,d1]
		case 'libquery'
			simple_features = [data(i).query_contexts data(i).lib_contexts];
		otherwise
			error('INVALID CHOICE');
	end
	
	% first level
	if K == 0
		features{i} = [simple_features zeros(L,2*d1+1)];
		continue;
	end
	
	% previous slot features
	prev_slot_simple_features = zeros(K,d1);
	for k = 1:K
		switch mode
			case 'lib'
				simple_features_k = data(i).lib_contexts(S(i,k),:);
			case 'query'
				simple_features_k = data(i).query_contexts(S(i,k),:);
			case 'libquery'
				simple_features_k = [data(i).query_contexts(S(i,k),:) data(i).lib_contexts(S(i,k),:)];
			otherwise
				error('INVALID CHOICE');
		end
		prev_slot_simple_features(k,:) = simple_features_k;
	end
	
	% very inefficient
	features_i = zeros(L,d);
	for j = 1:L
		diff_features = bsxfun(@minus,prev_slot_simple_features,simple_features(j,:));
		abs_diff_features = abs(diff_features); % size [K,d1].
		min_abs_diff_features = min(abs_diff_features,[],1); % [1,d1]
		mean_abs_diff_features = mean(abs_diff_features,1);
		features_i(j,:) = [simple_features(j,:) min_abs_diff_features mean_abs_diff_features 1];
	end
	
	features{i} = features_i;
end
end