clear; clc;
load toy_data

%%
lambda = 0; % regularizer
L = size(costs_train,2);
[w,obj] = train_multi_linear_subgradient_primal(features_train,costs_train,lambda);
[class_test_pred,scores_pred] = multi_linear_scorer_predict(features_test,w);
surrogate_risk = calc_surrogate_risk(costs_test,scores_pred);
true_risk = calc_true_risk(costs_test,class_test_pred);

%% holdout lambda
L = size(costs_train,2);
lambda_vec = linspace(1,100,10);
surrogate_risk_vec = zeros(size(lambda_vec));
true_risk_vec = zeros(size(lambda_vec));
w_list = cell(1,length(lambda_vec));
obj_list = cell(1,length(lambda_vec));
min_obj_list = zeros(size(lambda_vec));
scores_list = cell(1,length(lambda_vec));
for i = 1:length(lambda_vec)
    [w,obj] = train_multi_linear_subgradient_primal(features_train,costs_train,lambda_vec(i));
    [class_test_pred,scores_pred] = multi_linear_scorer_predict(features_test,w);
    scores_list{i} = scores_pred;
    surrogate_risk_vec(i) = calc_surrogate_risk(costs_test,scores_pred);
    true_risk_vec(i) = calc_true_risk(costs_test,class_test_pred);
    w_list{i} = w;
    obj_list{i} = obj;
    min_obj_list(i) = min(obj);
end

%% check sum zero constraint
x = zeros(1,length(features_train));
for i = 1:length(x)
    x(i) = features_train{i}(1,1);
end

hf = figure; hold all;
scores = zeros(length(x),L);
for i = 1:L
    scores(:,i) = w(1,i)*x+w(2,i);
    plot(x,scores(:,i));
    l{i} = int2str(i);
end
legend(l);

%% plot stuff
x = [0:0.001:1]';
y = zeros(length(x),L);

hf = figure; hold all;
l = cell(1,L);
for i = 1:L
    y(:,i) = w(1,i)*x+w(2,i);
    plot(x,y(:,i));
    l{i} = int2str(i);
end
legend(l);
