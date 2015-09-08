clear; clc;
load ../../regression/examples/dummy_train_data.mat
load ../../regression/examples/dummy_test_data.mat

%%
[features_train,costs_train] = data_transform_cs_classification(train_data,'query');
[features_test,costs_test] = data_transform_cs_classification(test_data,'query');

%%
lambda = 1; % regularizer
weights = train_linear_scorer(features_train,costs_train,lambda);
[class_pred,scores] = linear_scorer_predict(weights,features_test);

%%
fprintf('RMSE: %f\n',rms(y_pred-costs_test));