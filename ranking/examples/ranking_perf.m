[values_test,features_test,qids_test] = data_transform_ranking_training(validation_data,'libquery');

%% predict ranks
ranks_test = ranks_from_values(values_test,qids_test);
ranks_test_pred = predict_ranking_queries(features_test,qids_test,model_file_name);

%% calculate error
fprintf('Ranking error: %f\n',evaluate_ranking(ranks_test,qids_test,ranks_test_pred));
