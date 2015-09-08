%% initialize
clc;
clear;
close all;

%% Which set do you want to run it for?
set = 1;

%% 
global_dataset = getenv('DATASET');
switch(set)
    case 1
        %% Set 1: 2D planning dataset
        fprintf('Planner dataset \n');
        train_folder = strcat(global_dataset, 'planner_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, 'planner_dataset/validation_data.mat');
        lambda = 1e-3;
        threshold = 0; %local minima in thresh
        fail_thresh = 17.9;
end

%% train
load(train_folder);

N = length(train_data); % number of environments
B = 3; % budget length
weights_list = cell(1,B); % set of classifiers
C_list = cell(1,B); % set of (relative to best choice at budget level) losses
fraction_classified_list = zeros(1,B);
S = zeros(N,B); % list predicted during training

% sumbodular function parameters
submodular_fn_params.threshold = threshold;
[submodular_fn_params.global_max_cost,submodular_fn_params.global_min_cost] = ...
	get_global_cost_limits(train_data);
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
	% get features for level k
	% train level k
	% this function centers features
    [weights, obj, wset] = train_multi_linear_primal_sg_hinge(features,C,lambda);

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
	
%% test 
load(validation_folder);
S = predict_list_multilinear_cs_classification(validation_data,weights_list);
level_losses = evaluate_level_losses(validation_data,S,submodular_fn_params);
for k = 1:length(level_losses)
	fprintf('Loss at level %d: %.2f.\n',k,level_losses(k));
end
[mean_f,std_f] = evaluate_list_prediction(validation_data,S,submodular_fn_params);
fprintf('submodular f: %f %f\n', mean_f, std_f);
[e1,e2] = error_list_prediction(validation_data,S);
fprintf('Evaluation error: %f %f\n', e1, e2);

[failure] = failure_list_prediction( validation_data, S, fail_thresh);
for k = 1:length(failure)
    fprintf('Fraction failed: %f\n', failure(k));
end
