% initialize
% all parameters should be set in this block
% clc;
clear;
close all;

set = 4;
B = 3; % budget
surrogate_loss = 'hinge';

global_dataset = getenv('DATASET');
switch(set)
    case 1
        % Set 1: 2D planning dataset
        fprintf('2D Optimization dataset\n');
        train_folder = strcat(global_dataset, '2d_optimization_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, '2d_optimization_dataset/validation_data.mat');
        test_folder = strcat(global_dataset, '2d_optimization_dataset/test_data.mat');
        cost_threshold = 0;

    case 2
        % Set 2: Grasp dataset
        fprintf('Grasp dataset\n');
        train_folder = strcat(global_dataset, 'grasp_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, 'grasp_dataset/validation_data.mat');
        test_folder = strcat(global_dataset,'grasp_dataset/test_data.mat');
        cost_threshold = 0;
        
    case 3
        % Set 3: 2D planning dataset
        fprintf('Planner dataset \n');
        train_folder = strcat(global_dataset, 'planner_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, 'planner_dataset/validation_data.mat');
        test_folder = strcat(global_dataset, 'planner_dataset/test_data.mat');
        cost_threshold = 0;

    case 4
        % Set 4: Heuristic Learning
        fprintf('Heuristic dataset \n');
        train_folder = strcat(global_dataset, 'heuristic_dataset/train_data.mat');
        validation_folder = strcat(global_dataset, 'heuristic_dataset/validation_data.mat');
        test_folder = strcat(global_dataset, 'heuristic_dataset/test_data.mat');
        cost_threshold = 0;
        
    otherwise
        error('init_seqopt:invalid_set','Invalid dataset choice');
end

% sumbodular function parameters
load(train_folder,'train_data');
submodular_fn_params.threshold = cost_threshold;
[submodular_fn_params.global_max_cost,submodular_fn_params.global_min_cost] = ...
    get_global_cost_limits(train_data);

input_struct.B = B;
input_struct.surrogate_loss = surrogate_loss;
input_struct.train_folder = train_folder;
input_struct.validation_folder = validation_folder;
input_struct.test_folder = test_folder;
input_struct.submodular_fn_params = submodular_fn_params;


