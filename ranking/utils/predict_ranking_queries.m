function ranks = predict_ranking_queries(features,qids,fname_model)
% predict ranks for a set of queries

if nargin < 3
    fname_model = 'ranking_features.model';
end
ranks = [];
for i = unique(qids)'
    i
    ranks_i = predict_ranking_query(features(qids == i,:),fname_model);
    ranks = [ranks; ranks_i];
end
end