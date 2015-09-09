% initialize
clc;
clear;
close all;

set = 1;
B = 3; % budget length
surrogate_loss = 'hinge';

global_dataset = getenv('DATASET');
switch(set)
    case 1
        %% Set 1: 2D planning dataset
        fprintf('2D Optimization dataset\n');
        train_folder = strcat(global_dataset, '2d_optimization_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, '2d_optimization_dataset/validation_data.mat');
        lambda = 1e-3;
        threshold = 0; %1.4; %local minima in thresh
        %fail_thresh = 1.6;
    case 2
        %% Set 2: Grasp dataset
        fprintf('Grasp dataset\n');
        train_folder = strcat(global_dataset, 'grasp_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, 'grasp_dataset/validation_data.mat');
        lambda = 1e-3;
        threshold = 0; %20; % basically working only on unsolvable problems ...
        %fail_thresh = 39;
end

%% train
load(train_folder);

N = length(train_data); % number of environments
weights_list = cell(1,B); % set of classifiers
C_list = cell(1,B); % set of (relative to best choice at budget level) losses
features_list = cell(1,B); % set of features 
fraction_classified_list = zeros(1,B);
S = zeros(N,B); % list predicted during training
mode = 'query';
% sumbodular function parameters
submodular_fn_params.threshold = threshold;
[submodular_fn_params.global_max_cost,submodular_fn_params.global_min_cost] = ...
	get_global_cost_limits(train_data);

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
	features = conseqopt_features(train_data,S(:,1:k-1),mode); % features{i} is [L,d]
% 	features = conseqopt_scp_features(train_data,S(:,1:k-1),mode); % features{i} is [L,d]
	% train level k
	% this function centers features
	[weights,obj,wset] = train_linear_primal_sg(features, C,lambda,surrogate_loss);
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
	
%% test 
load(validation_folder);
S = predict_list_cs_classification(validation_data,weights_list,mode);
level_losses = evaluate_level_losses(validation_data,S,submodular_fn_params);
for k = 1:length(level_losses)
	fprintf('DEBUG: Loss at level %d: %.2f.\n',k,level_losses(k));
end

[e1,e2] = evaluate_list_prediction(validation_data,S);
fprintf('Evaluation error: %f %f\n', e1, e2);

