function features = conseqopt_features(data,S,mode)
% data is in common format
% S is [N,K]
% mode: {'lib','query','libquery'}
% features is cell array length N. features{i} is [L,d]

[N,K] = size(S);
features = cell(1,N);
L = length(data(1).costs);

for i = 1:N
	switch mode
		case 'lib'
			features{i} = data(i).lib_contexts;
		case 'query'
			features{i} = data(i).query_contexts;
		case 'libquery'
			features{i} = [data(i).query_contexts data(i).lib_contexts];
		otherwise
			error('INVALID CHOICE');
	end
	
	% append difference with features of past actions
	diff_features = [];
	for j = 1:K
		% no prediction, since environment already classified correctly
		if S(i,j) == 0
			diff_features = [diff_features zeros(size(features{i}))];
			continue;
		end	
		switch mode
			case 'lib'
				features_past_slot = data(i).lib_contexts(S(i,j),:);
			case 'query'
				features_past_slot = data(i).query_contexts(S(i,j),:);
			case 'libquery'
				features_past_slot = [data(i).query_contexts(S(i,j),:) data(i).lib_contexts(S(i,j),:)];
			otherwise
				error('INVALID CHOICE');
		end
		diff_features = [diff_features bsxfun(@minus,features{i},features_past_slot)];
	end
% 	features{i} = [features{i} diff_features ones(L,1)];
	
	% add bias
	features{i} = [features{i} ones(L,1)];
end

end