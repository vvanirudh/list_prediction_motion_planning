%
centers = [0.2 0.5 0.8];
L = length(centers);

%% training data
N = 200;
features_train = cell(1,N);
classes_train = zeros(1,N);
costs_train = ones(N,L);

for i = 1:N
    x = rand();
    d = abs(centers-x);
    features_train{i} = d';
    % bias
%     features_train{i} = [features_train{i} ones(L,1)];
    [~,classes_train(i)] = min(d);
    costs_train(i,classes_train(i)) = 0;
end

%% test data
N_test = 100;
features_test = cell(1,N_test);
classes_test = zeros(1,N_test);
costs_test = ones(N_test,L);

for i = 1:N_test
    x = rand();
    d = abs(centers-x);
    features_test{i} = d';
    % add bias
%     features_test{i} = [features_test{i} ones(L,1)];
    [~,classes_test(i)] = min(d);
    costs_test(i,classes_test(i)) = 0;
end

%% save
save('mats/toy_data_kernelized','L','centers','N','features_train','classes_train','costs_train', ...
    'N_test','features_test','classes_test','costs_test');