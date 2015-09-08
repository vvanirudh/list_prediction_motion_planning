clear; clc;
load toy_data_kernelized

%% train model
F_hat_train = wrap_features(features_train);
c_train = reshape(costs_train',numel(costs_train),1);
kernel_params.h = 0.1; % bandwidth
lambda = 10; % regularizer
[predictor, obj_vec, stats] = train_linear_kernelized_dual_pgd(F_hat_train,c_train,lambda,kernel_params);

%% test
[class_test_pred,scores] = linear_kernelized_scorer_predict(features_test,predictor);
x = [];
for i = 1:length(features_test)
    x = [x features_test{i}(1,1)];
end

surrogate_risk = calc_surrogate_risk(costs_test,scores);
true_risk = calc_true_risk(costs_test,class_test_pred);

hf = figure; hold all;
[x_sorted,ids_sorted] = sort(x);
legend_str = {};
for i = 1:L
    plot(x_sorted,scores(ids_sorted,i));
    legend_str{i} = int2str(i);
end
legend(legend_str);
