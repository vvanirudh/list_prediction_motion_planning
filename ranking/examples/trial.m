clear; clc;
load ../../regression/examples/dummy_train_data.mat
load ../../regression/examples/dummy_test_data.mat
[values_train,features_train,qids_train] = data_transform_ranking(train_data,'libquery');
[values_test,features_test,qids_test] = data_transform_ranking(test_data,'libquery');

%% predict ranks
train_ranking_model(values_train,features_train,qids_train);
ranks = predict_ranks(features_test(qids_test == 2,:));

%% delete some generated files
cleanup_ranking_files