function [X,y] = data_transform_regression(data,choice)
% data is in common format
% choice: {'lib','query','libquery'}

% X is n x dim
% Y is n x 1

num_data = length(data);

y = []; X = [];
for i = 1:num_data
    y = [y; data(i).original_costs - data(i).costs];
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
     X = [X; tmp];
end

% add bias
X = [X ones(size(X,1),1)];
end

