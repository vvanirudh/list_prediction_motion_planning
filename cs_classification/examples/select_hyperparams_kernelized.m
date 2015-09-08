% load training
clear; clc;
load ../../dataset/processed_dataset/train_data.mat
load ../../dataset/processed_dataset/validation_data.mat

[features_train,costs_train] = data_transform_cs_classification(train_data,'libquery');
[features_test,costs_test] = data_transform_cs_classification(validation_data,'libquery');

%% lambda sweep
[h_vec,lambda_vec] = meshgrid(linspace(0.01,3,5),linspace(0,2,5));
h_vec = h_vec(:); lambda_vec = lambda_vec(:);
[true_risk_vec,surrogate_risk_vec] = deal(zeros(size(h_vec)));
predictor_vec = cell(1,length(h_vec));
obj_vec = cell(1,length(h_vec));
F_hat_train = wrap_features(features_train);
c_train = reshape(costs_train',numel(costs_train),1);

N_test = size(costs_test,1);
for i = 1:length(h_vec)
    fprintf('Round %d\n',i);
    kernel_params.h = h_vec(i);
    lambda = lambda_vec(i);
    [predictor, obj] = train_linear_kernelized_dual_pgd(F_hat_train,c_train,lambda,kernel_params);
    predictor_vec{i} = predictor;
    obj_vec{i} = obj;
    [class_test_pred,scores] = linear_kernelized_scorer_predict(features_test,predictor);
    true_risk_vec(i) = calc_true_risk(costs_test,class_test_pred);
    surrogate_risk_vec(i) = calc_surrogate_risk(costs_test,scores);
end

%%
save('mats/hyperparams_sweep_linear_kernelized','h_vec','lambda_vec','predictor_vec','obj_vec','surrogate_risk_vec','true_risk_vec');
