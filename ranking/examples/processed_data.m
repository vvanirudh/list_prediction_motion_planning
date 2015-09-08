% load training
clear; clc;
load ../../dataset/processed_dataset/train_data.mat
load ../../dataset/processed_dataset/validation_data.mat

[values_train,features_train,qids_train] = data_transform_ranking_training(train_data,'libquery');
[values_test,features_test,qids_test] = data_transform_ranking(validation_data,'libquery');

%% train model
t1 = tic();
model_file_name = 'ranking_model';
train_ranking_model(values_train,features_train,qids_train,model_file_name);
fprintf('Training took %.2fs\n',toc(t1));

%% predict ranks
ranks_test = ranks_from_values(values_test,qids_test);
ranks_test_pred = predict_ranking_queries(features_test,qids_test,model_file_name);

%% calculate error
selected_idx = select_seed_ranking(ranks_test_pred,qids_test);
fprintf('Ranking error: %f\n',evaluate_ranking(ranks_test,qids_test,ranks_test_pred));
[e1, e2] = evaluate_prediction( validation_data, selected_idx );
fprintf('Evaluation error: %f %f\n', e1, e2);

%% viz
close all;
test_id = 1;
ranks_1 = ranks_test(qids_test == test_id);
ranks_2 = ranks_test_pred(qids_test == test_id);
viz_ranks(ranks_1,ranks_2);
viz_compare_seeds(ranks_1,ranks_2);