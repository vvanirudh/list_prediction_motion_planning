% initialize
% all parameters should be set in this block
% clc;
clear;
close all;

set = 2;
B = 3; % budget length
surrogate_loss = 'hinge';
% choices for features
features_choice_struct.append_lib_contexts = false;
features_choice_struct.append_down_levels = true;
features_choice_struct.append_type = 'averaging'; % {differencing,averaging}

global_dataset = getenv('DATASET');
switch(set)
    case 1
        % Set 1: 2D planning dataset
        fprintf('2D Optimization dataset\n');
        train_folder = strcat(global_dataset, '2d_optimization_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, '2d_optimization_dataset/validation_data.mat');
        test_folder = strcat(global_dataset, '2d_optimization_dataset/test_data.mat');

        lambda = 1e3;  
        %Validation statistics:
        %hinge: lambda 1e3 Budget 1: 0.1155 Budget 3: 0.0654  
        %square: lambda 1e2 Budget 1: 0.1172 Budget 3: 0.0662
        threshold = 0; %1.4; %local minima in thresh
        %fail_thresh = 1.6;
    case 2
        % Set 2: Grasp dataset
        fprintf('Grasp dataset\n');
        train_folder = strcat(global_dataset, 'grasp_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, 'grasp_dataset/validation_data.mat');
        lambda = 10; % 1e-3 is optimal
        threshold = 0; %20; % basically working only on unsolvable problems ...
        %fail_thresh = 39;
end

%% train
load(train_folder);
N = length(train_data); % number of environments
B = 3; % budget
list_weights = scp_list_weights(B); % size [1,B]

num_passes = 3; % number of passes through the data
total_rounds = num_passes*N;
lambda = lambda/total_rounds; % regularization
online_round = 1;

% initialize beta
if features_choice_struct.append_lib_contexts
	d1 = 2*size(train_data(1).query_contexts,2);
else
	d1 = size(train_data(1).query_contexts,2);
end
d = 3*d1+1;
beta = zeros(d,1);
beta_history = zeros(d,total_rounds); % set of regressors
subgrad_norm_history = zeros(1,total_rounds);

% sumbodular function parameters
submodular_fn_params.threshold = threshold;
[submodular_fn_params.global_max_cost,submodular_fn_params.global_min_cost] = ...
	get_global_cost_limits(train_data);

for pass = 1:num_passes
	% permute data order
	for i = randsample(1:N,N)
		% get list, features
		[S,features_list] = predict_list_scp_data_instance(train_data(i),beta,B,features_choice_struct);
		% get costs based on list
		C = scp_costs_data_instance(train_data(i),S,submodular_fn_params); % size [B,L]
		% calculate subgradient
		subgrad = calc_subgrad_scp_hinge_loss(features_list,C,list_weights,lambda,beta);
		% update with learning rate
		learning_rate = 1/sqrt(total_rounds);
		beta = beta-learning_rate*subgrad;
		beta_history(:,online_round) = beta;
		norm_subgrad_history(online_round) = norm(subgrad);
		online_round = online_round+1;
	end
end

%% Validation
load(validation_folder);

S = predict_list_scp(validation_data,beta,B,features_choice_struct);

level_losses = evaluate_level_losses(validation_data,S,submodular_fn_params);
for k = 1:length(level_losses)
	fprintf('DEBUG: Loss at level %d: %.2f.\n',k,level_losses(k));
end
[e1,e2] = evaluate_list_prediction(validation_data,S);
fprintf('Evaluation error: %f %f\n', e1, e2);
