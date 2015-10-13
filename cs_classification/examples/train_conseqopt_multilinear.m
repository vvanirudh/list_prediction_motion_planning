function weights_list = train_conseqopt_multilinear(input_struct)
    fprintf('Training.\n');
    B = input_struct.B;
    surrogate_loss = input_struct.surrogate_loss;
    train_folder = input_struct.train_folder;
    lambdas = input_struct.lambdas;
    submodular_fn_params = input_struct.submodular_fn_params;
    
    load(train_folder);
    
    N = length(train_data); % number of environments
    weights_list = cell(1,B); % set of classifiers
    C_list = cell(1,B); % set of (relative to best choice at budget level) losses
    fraction_classified_list = zeros(1,B);
    S = zeros(N,B); % list predicted during training
 
    [features, ~] = data_transform_multilinear_cs_classification(train_data);
    % train set of classifiers
    for k = 1:B
        % get losses for level k
        C = conseqopt_losses(train_data,S(:,1:k-1),submodular_fn_params); % size [N,L]
        if k > 1
            C_sum = sum(C,2);
            fraction_classified = sum(C_sum == 0)/size(C,1);
            fprintf('Fraction correctly classified at level %d: %.2f.\n',k-1,fraction_classified);
        end
        % train level k
        % this function centers features
        [weights, obj, wset] = train_multi_linear_primal_sg_hinge(features,C,lambdas(k),surrogate_loss);
        % prediction at level k
        [S(:,k),~] = multi_linear_scorer_predict(features,weights);
        
        % logging
        C_list{k} = C;
        if k > 1
            fraction_classified_list(k) = fraction_classified;
        end
        weights_list{k} = weights;
    end
    
    C = conseqopt_losses(train_data, S, submodular_fn_params); % size [N,L]
    C_sum = sum(C,2);
    fraction_classified = sum(C_sum == 0)/size(C,1);
    fprintf('Fraction correctly classified at level %d: %.2f.\n',B,fraction_classified);
    fraction_classified_list(end) = fraction_classified;
end