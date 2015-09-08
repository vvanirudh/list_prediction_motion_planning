% load training
clear; clc;
load ../../dataset/processed_dataset/train_data.mat
load ../../dataset/processed_dataset/validation_data.mat

[features_train,costs_train] = data_transform_cs_classification(train_data,'libquery');
[features_test,costs_test] = data_transform_cs_classification(validation_data,'libquery');
train_data = train_data(1:5);

%% train model
F_hat_train = wrap_features(features_train);
c_train = reshape(costs_train',numel(costs_train),1);
kernel_params.h = 1; % bandwidth
lambda = 1; % regularizer
t1 = tic();
[predictor, obj, stats] = train_linear_kernelized_dual_pgd(F_hat_train,c_train,lambda,kernel_params);
fprintf('Computation took %.2fs\n',toc(t1));

%% predict ranks
[class_test_pred,scores_pred] = linear_kernelized_scorer_predict(features_test,predictor);
ranks_test = ranks_from_scores(costs_test);
ranks_test_pred = ranks_from_scores(scores_pred);

%% calculate error
selected_idx = class_test_pred;
[e1, e2] = evaluate_prediction( validation_data, selected_idx );
fprintf('Evaluation error: %f %f\n', e1, e2);

