% initialize
% all parameters should be set in this block
% clc;
clear;
close all;

set = 2;
B = 3; % budget
surrogate_loss = 'hinge';
% choices for features
features_choice_struct.append_lib_contexts = 0;
features_choice_struct.append_down_levels = 1;
features_choice_struct.append_type = 'averaging'; % {differencing,averaging}

global_dataset = getenv('DATASET');
switch(set)
    case 1
        % Set 1: 2D planning dataset
        fprintf('2D Optimization dataset\n');
        train_folder = strcat(global_dataset, '2d_optimization_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, '2d_optimization_dataset/validation_data.mat');
        test_folder = strcat(global_dataset, '2d_optimization_dataset/test_data.mat');

        lambdas = 1e3*ones(1,B);  
        %Validation statistics:
        %hinge: lambda 1e3 Budget 1: 0.1155 Budget 3: 0.0654  
        %square: lambda 1e2 Budget 1: 0.1172 Budget 3: 0.0662
        cost_threshold = 0; %1.4; %local minima in thresh
        %fail_thresh = 1.6;
    case 2
        % Set 2: Grasp dataset
        fprintf('Grasp dataset\n');
        train_folder = strcat(global_dataset, 'grasp_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, 'grasp_dataset/validation_data.mat');
        test_folder = strcat(global_dataset,'grasp_dataset/test_data.mat');
        lambdas = 1e-3*ones(1,B); % 1e-3 is optimal
        cost_threshold = 0; %20; % basically working only on unsolvable problems ...
        %fail_thresh = 39;
end

% sumbodular function parameters
load(train_folder,'train_data');
submodular_fn_params.threshold = cost_threshold;
[submodular_fn_params.global_max_cost,submodular_fn_params.global_min_cost] = ...
    get_global_cost_limits(train_data);

input_struct.B = B;
input_struct.surrogate_loss = surrogate_loss;
input_struct.features_choice_struct = features_choice_struct;
input_struct.train_folder = train_folder;
input_struct.validation_folder = validation_folder;
input_struct.test_folder = test_folder;
input_struct.lambdas = lambdas;
input_struct.submodular_fn_params = submodular_fn_params;


