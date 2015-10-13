function static_list = train_seqopt(input_struct)
    fprintf('Training.\n');
    B = input_struct.B;
    train_folder = input_struct.train_folder;
    submodular_fn_params = input_struct.submodular_fn_params;
    
    load(train_folder);
    N = length(train_data); % number of environments
    static_list = zeros(1,B); % set of classifiers
    C_list = cell(1,B); % set of (relative to best choice at budget level) losses
    fraction_classified_list = zeros(1,B);
    S = zeros(N,B); % list predicted during training
    
    % train set of classifiers
    for k = 1:B
        % get losses for level k
        C = conseqopt_losses(train_data,S(:,1:k-1),submodular_fn_params); % size [N,L]
        already_classified = (sum(C,2) == 0);
        if k > 1
            fraction_classified = sum(already_classified)/size(C,1);
            fprintf('DEBUG: Fraction correctly classified at level %d: %.2f.\n',k-1,fraction_classified);
        end
        if sum(already_classified) == N
            static_list(k) = randi(L); % no reason to pick a particular element
            continue;
        end
        
        empirical_element_risks = sum(C,1)/sum(~already_classified);
        [~,static_list(k)] = min(empirical_element_risks);
        S(:,k) = static_list(k);
        
        % logging
        C_list{k} = C;
        if k > 1
            fraction_classified_list(k) = fraction_classified;
        end
    end
    
    C = conseqopt_losses(train_data,S,submodular_fn_params); % size [N,L]
    C_sum = sum(C,2);
    fraction_classified = sum(C_sum == 0)/size(C,1);
    fprintf('DEBUG: Fraction correctly classified at level %d: %.2f.\n',B,fraction_classified);
    fraction_classified_list(end) = fraction_classified;
end