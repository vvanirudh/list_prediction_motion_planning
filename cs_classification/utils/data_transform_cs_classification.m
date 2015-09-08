function [features,costs] = data_transform_cs_classification(data,choice)
% data is in common format
% choice: {'lib','query','libquery'}

% features is a cell array of length num instances. features{i} is an array of size 
% L x d
% costs is an array of size N x L

n = length(data);
features = cell(1,n);

for i = 1:n
    switch choice
        case 'lib'
            features{i} = data(i).lib_contexts;
        case 'query'
            features{i} = data(i).query_contexts;
        case 'libquery'
            features{i} = [data(i).query_contexts data(i).lib_contexts];
        otherwise
            error('INVALID CHOICE');
    end
    c = data(i).costs';
    c = c-min(c);
    costs(i,:) = c;
    % add bias
    features{i} = [features{i} ones(length(c),1)];
end

end