clear; clc;
load ../../regression/examples/dummy_train_data.mat
load ../../regression/examples/dummy_test_data.mat
[labels_train,pts_train] = data_transform_clustering(train_data,'query');
[labels_test,pts_test] = data_transform_clustering(test_data,'query');

%%
[err,d] = knncl([],pts_train,labels_train,pts_test,labels_test,1);
[L,~] = lmnn2(pts_train,labels_train,'quiet',1);
errL = knncl(L,pts_train,labels_train,pts_test,labels_test,1);
