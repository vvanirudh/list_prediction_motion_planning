% load training
load ../../dataset/processed_dataset/train_data.mat
load ../../dataset/processed_dataset/validation_data.mat

[X_train,y_train] = data_transform_regression(train_data,'query');
[X_test,y_test] = data_transform_regression(validation_data,'query');
lambda_set = logspace(-10,0,100);

% rms_set = [];
% for lambda = lambda_set
%     
%     rms_set = [rms_set; rms(y_pred-y_test)];
% end
% 
% semilogx(lambda_set, rms_set);
lambda = 1;
[y_pred,beta] = linear_regression(X_train,y_train,X_test,lambda);
fprintf('RMSE: %f\n',rms(y_pred-y_test));

selected_idx = select_seed_linear_regression( validation_data, beta, 'query' );
[e1, e2] = evaluate_prediction( validation_data, selected_idx );
fprintf('Evaluation error: %f %f\n', e1, e2);
