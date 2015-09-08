% load training
load ../../dataset/processed_dataset/train_data.mat
load ../../dataset/processed_dataset/validation_data.mat

[labels_train,pts_train] = data_transform_clustering(train_data,'query');
pts_library = get_library_features(train_data);
[labels_test,pts_test] = data_transform_clustering(validation_data,'query');

[L,~] = lmnn2(pts_train,labels_train,'quiet',4);
% L = [];

%% option 1: use training data
k = 5;
[err,stats] = knncl(L,pts_train,labels_train,pts_test,labels_test,k);
labels_pred = stats.lTe2(end,:);
%% option 2: dist to library
labels_pred = nn_library(L,pts_library,pts_test);

%% 
selected_idx = labels_pred;
fprintf('Classification error: %f\n', evaluate_clustering(labels_test,labels_pred));
fprintf('Evaluation error: %f\n', evaluate_prediction( validation_data, selected_idx ));

