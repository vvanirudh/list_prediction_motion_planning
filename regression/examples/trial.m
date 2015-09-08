% load training
load dummy_train_data

% load query
load dummy_test_data

[X_train,y_train] = data_transform_regression(train_data,'query');
[X_test,y_test] = data_transform_regression(test_data,'query');
[y_pred,beta] = linear_regression(X_train,y_train,X_test,1);

fprintf('RMSE: %f\n',rms(y_pred-y_test));


