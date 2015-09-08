clear; clc;
L = 10;
dim_feat = 3;
for i = 1:10
    train_data(i).original_costs = zeros(L,1);
    train_data(i).costs = rand(L,1);
    train_data(i).lib_contexts = rand(L,dim_feat);
    train_data(i).query_contexts = rand(L,dim_feat);
end

for i = 1:5
    test_data(i).original_costs = zeros(L,1);
    test_data(i).costs = rand(L,1);
    test_data(i).lib_contexts = rand(L,dim_feat);
    test_data(i).query_contexts = rand(L,dim_feat);
end

save('dummy_train_data','train_data');
save('dummy_test_data','test_data');
