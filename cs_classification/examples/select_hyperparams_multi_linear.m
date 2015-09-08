% load training
clear; clc;
load ../../dataset/processed_dataset/train_data.mat
load ../../dataset/processed_dataset/validation_data.mat

[features_train,costs_train] = data_transform_cs_classification(train_data,'libquery');
[features_test,costs_test] = data_transform_cs_classification(validation_data,'libquery');

%% lambda sweep
lambda_vec = linspace(1,10,20);
[true_risk_vec,surrogate_risk_vec] = deal(zeros(size(lambda_vec)));
weights_vec = cell(1,length(lambda_vec));

N_test = size(costs_test,1);
for i = 1:length(lambda_vec)
    fprintf('Round %d\n',i);
    lambda = lambda_vec(i);
    [weights, obj] = train_multi_linear_subgradient_primal(features_train,costs_train,lambda);
    [class_test_pred,scores] = multi_linear_scorer_predict(features_test,weights);
    true_risk_vec(i) = calc_true_risk(costs_test,class_test_pred);
    surrogate_risk_vec(i) = calc_surrogate_risk(costs_test,scores);
end

%%
save('hyperparams_sweep_multi_linear','lambda_vec','surrogate_risk_vec','true_risk_vec','weights_vec');
