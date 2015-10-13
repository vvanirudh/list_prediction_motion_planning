function weights_list = train_conseqopt_linear(input_struct)
    fprintf('Training.\n');
    B = input_struct.B;
    surrogate_loss = input_struct.surrogate_loss;
    features_choice_struct = input_struct.features_choice_struct;
    train_folder = input_struct.train_folder;
    lambdas = input_struct.lambdas;
    submodular_fn_params = input_struct.submodular_fn_params;
    
    
    load(train_folder);
    N = length(train_data); % number of environments
    weights_list = cell(1,B); % set of classifiers
    C_list = cell(1,B); % set of (relative to best choice at budget level) losses
    features_list = cell(1,B); % set of features
    fraction_classified_list = zeros(1,B);
    S = zeros(N,B); % list predicted during training
    
    % train set of classifiers
    for k = 1:B
        % get losses for level k
        C = conseqopt_losses(train_data,S(:,1:k-1),submodular_fn_params); % size [N,L]
        if k > 1
            C_sum = sum(C,2);
            fraction_classified = sum(C_sum == 0)/size(C,1);
            fprintf('DEBUG: Fraction correctly classified at level %d: %.2f.\n',k-1,fraction_classified);
        end
        % get features for level k
        features = conseqopt_features(train_data,S(:,1:k-1),features_choice_struct); % features{i} is [L,d]
        % train level k
        % this function centers features
        [weights,obj,wset] = train_linear_primal_sg(features, C,lambdas(k),surrogate_loss);
        % prediction at level k
        [S(:,k),~] = linear_scorer_predict(features,weights);
        
        % logging
        C_list{k} = C;
        features_list{k} = features;
        if k > 1
            fraction_classified_list(k) = fraction_classified;
        end
        weights_list{k} = weights;
    end
    
    C = conseqopt_losses(train_data,S,submodular_fn_params); % size [N,L]
    C_sum = sum(C,2);
    fraction_classified = sum(C_sum == 0)/size(C,1);
    fprintf('DEBUG: Fraction correctly classified at level %d: %.2f.\n',B,fraction_classified);
    fraction_classified_list(end) = fraction_classified;
end