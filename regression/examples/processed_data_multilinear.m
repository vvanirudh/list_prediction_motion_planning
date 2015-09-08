% load training
load ../../planner_dataset/train_data.mat
load ../../planner_dataset/validation_data.mat

[features_train,costs_train] = data_transform_multilinear_regression(train_data);
[features_test,costs_test] = data_transform_multilinear_regression(validation_data);

%% train model
t1 = tic();
lambda = 100; % regularizer
[weights, obj, wset] = train_multi_linear_square(features_train,costs_train,lambda);
fprintf('Computation took %.2fs\n',toc(t1));

%% predict ranks
[class_test_pred,scores_pred] = multi_linear_scorer_predict_regression(features_test,weights);
ranks_test = ranks_from_scores(costs_test);
ranks_test_pred = ranks_from_scores(scores_pred);

%% calculate error
selected_idx = class_test_pred;
[e1, e2] = evaluate_prediction( validation_data, selected_idx );
fprintf('Evaluation error: %f %f\n', e1, e2);
