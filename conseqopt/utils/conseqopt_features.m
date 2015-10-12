function features = conseqopt_features(data,S,choices)
% data is in common format
% S is [N,K]
% choices: struct with fields
% ('append_lib_contexts','append_down_levels','append_type')
% features is cell array length N. features{i} is [L,d]

% this function is for data with environment + element features
% does not make sense for data with environment-only features
assert(isfield(data(1),'query_contexts'),'conseqopt_features:format_error', ...
    'data requires field query_contexts');

[N,K] = size(S);
features = cell(1,N);
L = length(data(1).costs);

for i = 1:N
    if choices.append_lib_contexts
        features{i} = [data(i).query_contexts data(i).lib_contexts];
    else
        features{i} = [data(i).query_contexts];
    end
    
    if choices.append_down_levels
        switch choices.append_type
            case 'differencing'
                features{i} = append_features_differencing(data(i),features{i},S(i,:),choices);
            case 'averaging'
                features{i} = append_features_averaging(data(i),features{i},S(i,:),choices);
            otherwise
                error('conseqopt_features:invalid_choice', ...
                    'append_type \in \{differencing,averaging\}');
        end
    end

    % add bias
	features{i} = [features{i} ones(L,1)];
end

end

function features_i = append_features_differencing(data_i,features_i,S_i,choices)
    % subscript i emphasizes that variables are for a single environment
    % from conseqopt paper
        
    % append difference with features of past elements
    K = length(S_i);
    diff_features = [];
    for j = 1:K
        % no prediction, since environment already classified correctly
        if S_i(j) == 0
            diff_features = [diff_features zeros(size(features_i))];
            continue;
        end
        if choices.append_lib_contexts
            features_past_slot = [data_i.query_contexts(S_i(j),:) data_i.lib_contexts(S_i(j),:)];
        else
            features_past_slot = [data_i.query_contexts(S_i(j),:)];
        end
        
        diff_features = [diff_features bsxfun(@minus,features_i,features_past_slot)];
    end
    features_i = [features_i diff_features];
end


function features_i = append_features_averaging(data_i,simple_features_i,S_i,choices)
    % subscript i emphasizes that variables are for a single environment
    % from scp paper
    
    K = length(S_i);
    [L,d_simple] = size(simple_features_i);
        
    % first level, nothing to average over
	if K == 0
		features_i = [simple_features_i zeros(L,2*d_simple)];
		return;
	end
	
	% previous slot features
    % simple are averaged and appended
	prev_slot_simple_features = zeros(K,d_simple);
	for k = 1:K
        if choices.append_lib_contexts
            simple_features_k = [data_i.query_contexts(S_i(k),:) data_i.lib_contexts(S_i(k),:)];
        else
            simple_features_k = [data_i.query_contexts(S_i(k),:)];
        end
		prev_slot_simple_features(k,:) = simple_features_k;
	end
	
	% very inefficient
    features_i = zeros(L,3*d_simple);
	for j = 1:L
		diff_features = bsxfun(@minus,prev_slot_simple_features,simple_features_i(j,:));
		abs_diff_features = abs(diff_features); % size [K,d1].
		min_abs_diff_features = min(abs_diff_features,[],1); % [1,d1]
		mean_abs_diff_features = mean(abs_diff_features,1);
		features_i(j,:) = [simple_features_i(j,:) min_abs_diff_features mean_abs_diff_features];
	end
end










