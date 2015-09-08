function [values,features,qids] = data_transform_ranking_training(data,choice)
% data is in common format
% choice: {'lib','query','libquery'}

% values is n x 1
% features is n x dim
% qids is n x 1

num_data = length(data);
num_lib = length(data(1).costs);

values = []; features = []; qids = [];
qid_count  = 0;
for i = 1:num_data
    i
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

%     
     [min_v, id_min ] = min(data(i).costs);
     min_f = tmp(id_min, :);
     
     rem_f = tmp(data(i).costs > 0.5 + min_v, :);
%     %rem_f(end,:) = [];
%     %rem_f = tmp(1:end ~= id_min, :);
     
     qids = [qids; reshape(repmat((qid_count+1):(qid_count + size(rem_f,1)), 2, 1), [], 1)];
     qid_count = qid_count + size(rem_f,1);
     values = [values; repmat([2; 1], size(rem_f,1), 1)];
     features = [features; transpose(reshape(transpose([repmat(min_f, size(rem_f,1), 1) rem_f] ), size(min_f,2), []))];
    
% for j = 1:5
%     [min_v, id_min ] = min(data(i).costs);
%     min_f = tmp(id_min, :);
%     
%     [~, sel_id] = sort(data(i).costs, 'descend');
%     
%     rem_f = tmp(sel_id(1:5), :);
%     rem_f(end,:) = [];
%     rem_f = tmp(1:end ~= id_min, :);
%     
%     qids = [qids; reshape(repmat((qid_count+1):(qid_count + size(rem_f,1)), 2, 1), [], 1)];
%     qid_count = qid_count + size(rem_f,1);
%     values = [values; repmat([2; 1], size(rem_f,1), 1)];
%     features = [features; transpose(reshape(transpose([repmat(min_f, size(rem_f,1), 1) rem_f] ), size(min_f,2), []))];
%     tmp(id_min, :) = [];
%     data(i).costs(id_min) = [];
% end
end
end