function [values,features,qids] = data_transform_ranking(data,choice)
% data is in common format
% choice: {'lib','query','libquery'}

% values is n x 1
% features is n x dim
% qids is n x 1

num_data = length(data);
num_lib = length(data(1).costs);

values = []; features = []; qids = [];
for i = 1:num_data
    qids = [qids; i*ones(num_lib,1)];
    values = [values; -data(i).costs];
    switch choice
        case 'lib'
            tmp = data(i).lib_contexts;
        case 'query'
            tmp = data(i).query_contexts;
        case 'libquery'
            tmp = [data(i).query_contexts data(i).lib_contexts];
        otherwise
            error('INVALID CHOICE');
    end
    features = [features; tmp];
end
end