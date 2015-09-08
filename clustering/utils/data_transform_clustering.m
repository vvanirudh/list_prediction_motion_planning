function [labels,pts] = data_transform_clustering(data,choice)
% data is in common format
% choice: {'lib','query','libquery'}

% labels is n x 1
% pts is dim x n

num_data = length(data);

labels = []; pts = [];
for i = 1:num_data
     minv = inf;
     while (1)
         [v, id] = min(data(i).costs);
         if (v < minv)
             minv = v;
         end
         if (v > minv + 0.05)
             break;
         end
         labels = [labels; id];
         switch choice
            case 'lib'
                error('QUERY ONLY CHOICE IN CLUSTERING');
            case 'query'
                tmp = data(i).query_contexts(id,:);
            case 'libquery'
                error('QUERY ONLY CHOICE IN CLUSTERING');
            otherwise
                error('INVALID CHOICE');
         end
         pts = [pts; tmp];
         data(i).costs(id) = [];
     end
end
labels = labels';
pts = pts';
end
